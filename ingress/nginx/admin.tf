// Based on https://github.com/terraform-providers/terraform-provider-kubernetes/issues/322

data "google_service_account" "terraform" {
  account_id = "terraform"
}

resource "kubernetes_cluster_role_binding" "owner_cluster_admin_binding" {
  metadata {
    name = "owner-cluster-admin-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "cluster-admin"
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "User"
    name      = "${data.google_service_account.terraform.email}"
  }
  # must create a binding on unique ID of SA too
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "User"
    name      = "${data.google_service_account.terraform.unique_id}"
  }
}