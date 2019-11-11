all: cluster ingress

cloudauth:
	echo "token = \"`gcloud auth application-default print-access-token`\"" > terraform.tfvars

cluster: cloudauth
	terraform apply --auto-approve
	
kubeauth:
	gcloud container clusters get-credentials primary --region=us-central1

ingress: kubeauth
	kubectl apply -f ingress/nginx