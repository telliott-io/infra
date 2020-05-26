package secrets

import (
	"crypto/rsa"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"path"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes/scheme"
	"k8s.io/client-go/util/cert"
	"sigs.k8s.io/kind/pkg/cluster"
	"sigs.k8s.io/kind/pkg/cmd"

	sealedsecrets "github.com/bitnami-labs/sealed-secrets/pkg/apis/sealed-secrets/v1alpha1"

	// Register Auth providers
	_ "k8s.io/client-go/plugin/pkg/client/auth"
)

func TestSigning(t *testing.T) {
	if testing.Short() {
		t.Skip()
	}

	tfdir := "testdata"
	workingDirCleanup, err := setupWorkingDir(tfdir)
	if err != nil {
		t.Fatal(err)
	}
	defer workingDirCleanup()

	kubeconfigfile := "kindconfig"
	kindCleanup, err := createKindCluster(path.Join(tfdir, kubeconfigfile))
	if err != nil {
		t.Fatal(err)
	}
	defer kindCleanup()

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: tfdir,
		Vars: map[string]interface{}{
			"signing_cert": signingCert,
			"signing_key":  signingKey,
		},
	}

	// At the end of the test, run `terraform destroy`
	// TODO: Determine why this doesn't work
	//defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`
	result := terraform.InitAndApply(t, terraformOptions)
	t.Logf("Stdout: %v", result)

	ss, err := sealTestSecret()
	if err != nil {
		t.Fatal(err)
	}
	ss.APIVersion = "bitnami.com/v1alpha1"
	ss.Kind = "SealedSecret"
	ssJSON, err := json.Marshal(ss)
	if err != nil {
		t.Fatal(err)
	}

	sealedSecretFile := "secret.json"
	sealedSecretPath := path.Join(tfdir, sealedSecretFile)
	err = ioutil.WriteFile(sealedSecretPath, ssJSON, 0644)
	if err != nil {
		log.Fatal(err)
	}
	defer func() {
		err := os.Remove(sealedSecretPath)
		if err != nil {
			t.Log(err)
		}
	}()

	// Create secret
	output, err := execKubectl(tfdir, kubeconfigfile, []string{"apply", "-f", sealedSecretFile})
	if err != nil {
		t.Fatal(err)
	}

	// Sleep for 1s
	time.Sleep(time.Second)

	// Get new secret value
	output, err = execKubectl(tfdir, kubeconfigfile, []string{"get", "secret", "mysecret", "-o", "jsonpath=\"{.data.foo}\""})
	if err != nil {
		t.Fatal(err)
	}
	encoded := strings.Replace(string(output), "\"", "", 2)
	data, err := base64.StdEncoding.DecodeString(encoded)
	if err != nil {
		t.Error(err)
	}
	if string(data) != secretValue {
		t.Errorf("generated secret incorrect. expected %q, got %q", secretValue, string(data))
	}

}

func setupWorkingDir(p string) (func() error, error) {
	err := os.Mkdir(p, os.ModePerm)
	if err != nil {
		return func() error { return nil }, err
	}
	err = ioutil.WriteFile(path.Join(p, "main.tf"), []byte(mainTF), 0644)
	if err != nil {
		log.Fatal(err)
	}
	return func() error {
		return os.RemoveAll(p)
	}, nil
}

func execKubectl(tfdir, kubeconfigfile string, params []string) (string, error) {
	cmd := exec.Command("kubectl", params...)
	cmd.Env = []string{
		fmt.Sprintf("KUBECONFIG=%s", kubeconfigfile),
	}
	cmd.Dir = tfdir
	output, err := cmd.CombinedOutput()
	if err != nil {
		return "", err
	}
	return string(output), nil
}

func sealTestSecret() (*sealedsecrets.SealedSecret, error) {
	pubKey, err := parseKey(strings.NewReader(signingCert))
	if err != nil {
		return nil, err
	}
	return sealedsecrets.NewSealedSecret(scheme.Codecs, pubKey, secretObj)
}

func parseKey(r io.Reader) (*rsa.PublicKey, error) {
	data, err := ioutil.ReadAll(r)
	if err != nil {
		return nil, err
	}

	certs, err := cert.ParseCertsPEM(data)
	if err != nil {
		return nil, err
	}

	// ParseCertsPem returns error if len(certs) == 0, but best to be sure...
	if len(certs) == 0 {
		return nil, errors.New("Failed to read any certificates")
	}

	cert, ok := certs[0].PublicKey.(*rsa.PublicKey)
	if !ok {
		return nil, fmt.Errorf("Expected RSA public key but found %v", certs[0].PublicKey)
	}

	return cert, nil
}

func createKindCluster(kubeConfig string) (func() error, error) {
	kindProvider := cluster.NewProvider(
		cluster.ProviderWithLogger(
			cmd.NewLogger(),
		),
	)
	err := kindProvider.Create(
		"kind-test",
		cluster.CreateWithNodeImage("kindest/node:v1.16.9"),
		cluster.CreateWithRetain(false),
		cluster.CreateWithWaitForReady(time.Duration(0)),
		cluster.CreateWithKubeconfigPath(kubeConfig),
		cluster.CreateWithDisplayUsage(true),
		cluster.CreateWithDisplaySalutation(true),
	)
	if err != nil {
		return nil, err
	}
	return func() error {
		var errstrings []string
		err1 := kindProvider.Delete("kind-test", "")
		if err1 != nil {
			errstrings = append(errstrings, err1.Error())
		}
		err2 := os.Remove(kubeConfig)
		if err2 != nil {
			errstrings = append(errstrings, err2.Error())
		}
		return fmt.Errorf(strings.Join(errstrings, "\n"))
	}, nil
}

const signingCert = `
-----BEGIN CERTIFICATE-----
MIIFoDCCA4gCCQCcwV/Fhn/3/TANBgkqhkiG9w0BAQsFADCBkTELMAkGA1UEBhMC
VVMxCzAJBgNVBAgMAk5ZMREwDwYDVQQHDAhOZXcgWW9yazEUMBIGA1UECgwLdGVs
bGlvdHQuaW8xDjAMBgNVBAsMBUluZnJhMRQwEgYDVQQDDAt0ZWxsaW90dC5pbzEm
MCQGCSqGSIb3DQEJARYXdG9tLncuZWxsaW90dEBnbWFpbC5jb20wHhcNMjAwNTI0
MTMxNDU0WhcNMjEwNTI0MTMxNDU0WjCBkTELMAkGA1UEBhMCVVMxCzAJBgNVBAgM
Ak5ZMREwDwYDVQQHDAhOZXcgWW9yazEUMBIGA1UECgwLdGVsbGlvdHQuaW8xDjAM
BgNVBAsMBUluZnJhMRQwEgYDVQQDDAt0ZWxsaW90dC5pbzEmMCQGCSqGSIb3DQEJ
ARYXdG9tLncuZWxsaW90dEBnbWFpbC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDNVf4Oxzb6tRmPNtxrYHjM8oSHOvP/9xsZkUY1qMN2CKPU8GzR
8ZGgv3bZjW+UfgIm+/iFppkrM5adAQz+v6cwD9mY9rxBW9iJ6pAb2t1a4x35Zces
Z8YTc902VdAchF2PXs/pLY/IcHm87vwh7mpvGqv58Vu6LwmovaMx+XALyyN+2e2l
pq0vSXJy+vqnXjQbafim5qFy3sFoMIsNImyNY0ak7k0vQQQYKivDiT8u4XHd9klQ
rsXwCwF+P6XcdFIxYeelAFv3g56jEh8be8TV1xKJvzqUOI4P/Gm9ynv6ovD1XsXE
WilvnwBMaCug7riv04Bl2v7C4lGDT6NRXH+CfkC3UKo3sKZ5IjPvZ82cGubzYOym
PGM6QuyDrAOPk/0/DvqN3QcS45GjOPvjENn//lAcldTmv65ktYnCh0I9da+gtbrY
+3bdeIYyvzx2GW52aDvqUW6eWpGop5GtiTAmi4WU6e18q1fxhC+INILqtIv+9RWU
dW9+9tBn/aE4i8yPcgLyNs4zF6Le8d0GMDkzX35vundC/KCg5r8xlknNARuWsc6d
Zw2/okMZe9fOZ7EYlurPcr6o/0cN1+JO6o0ygT9gm/mp0i6GcWeDLZpzFAfgu5n3
z0LmCBJRFHL7fgMbDezl5SV133curUwm6QThmtfCPsnYuCxS53WG23uGTwIDAQAB
MA0GCSqGSIb3DQEBCwUAA4ICAQBWCCprg2sc0e4wQQh3Gtyx5pUjIkt0JbgvpC/6
C5XzAmyHaYfOKrSm2XM84m6MBBN9f7I2G6cN2Fab4c9fIXMDqJhwKKfvJF3xq87r
s1VoJRT67xd2TBx7Jk/v1AUZlvu2uV7Ku7uewCljV+gtJMtf6n5JmUAOEqU1eZ5k
yWIHu0gigYjYSoDXeJJEVMFOzG2gVW0Nkwg+Pi49PLqqh2STXTY3EysURSzHCuxN
g1LbkAL3u7gy7eCDOTddruYVd/ZphpxTnxwYQ2Y+7VkYyZEUM4l5uecn5Dl/7fD9
+gA0xHrmMSUyov+Mo9XVOc1PYgaMj4Oho+ZKS4Nyt3N41txq4CRsue0wmiOKxSvf
dvrbX3ZjWJqQmjQqJMWpWWfUSjSJbZL/VQg+Bj1q2t9mn8fQJzleUBwqd2/JEcu3
MDTIss2vRPOAvLK8NYzzrIl2R0Hpl+fYKNfZNa3MaxUB+IM2Rv/k3lbIXyUQ6R+p
NJN6o3sVn5qA3jiUD/yrMMbPV56KWYdS36Hq2d2s+2T3zIDWwr+fYryb+W/oiKFA
sLr3jmpgWwCUrmcmthjRR4qJ0NaGtDGzOc6vUk7YbY8AoruG8J7K3Rj5F3/BSBw9
RqcivwnkKB4zxzVjdwznUkfp5aaG7TRn8f4BNZu4TaNYRJloNW4xvrv+Gdo/3Xn7
uIr1ZA==
-----END CERTIFICATE-----
`

const signingKey = `
-----BEGIN PRIVATE KEY-----
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
0UuyW6PdDTYvKVmj9+wNHe+dkK4Wlg==
-----END PRIVATE KEY-----
`

const secretValue = "bar"

const mainTF = `
module "secrets" {
    source = "../"
    signing_cert = var.signing_cert
    signing_key = var.signing_key
}

provider "kubernetes" {
    config_path = "${path.module}/kindconfig"
}

provider "helm" {
    kubernetes {
        config_path = "${path.module}/kindconfig"
    }
}

variable signing_cert {}
variable signing_key {}
`

var secretObj = &v1.Secret{
	ObjectMeta: metav1.ObjectMeta{
		Name:      "mysecret",
		Namespace: "default",
	},
	Data: map[string][]byte{
		"foo": []byte(secretValue),
	},
}
