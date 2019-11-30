module "jaeger" {
    source   = "./jaeger"
}

module "prometheus" {
    source   = "./prometheus"
}

module "grafana" {
    source   = "./grafana"
}