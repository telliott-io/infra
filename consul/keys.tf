# Configure the Consul provider
provider "consul" {
  address    = "${var.consul_address}"
  datacenter = "dc1"
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "${path.module}/wait_for_url.sh ${var.consul_address}"
  }
  triggers = {
    "before" = "${length(kubernetes_ingress.consul.load_balancer_ingress)}"
  }
}

resource "consul_keys" "deployment" {
  depends_on = [null_resource.delay]

  # Set the CNAME of our load balancer as a key
  key {
    path  = "deployment/name"
    value = "${var.deployment_name}"
  }
}

variable deployment_name {
}

variable consul_address {
}