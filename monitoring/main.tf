module "jaeger" {
    source   = "./jaeger"
    module_depends_on = ["${kubernetes_namespace.monitoring}"]
}

module "prometheus" {
    source   = "./prometheus"
    module_depends_on = ["${kubernetes_namespace.monitoring}"]
}

module "grafana" {
    source   = "./grafana"
    module_depends_on = ["${kubernetes_namespace.monitoring}"]
}