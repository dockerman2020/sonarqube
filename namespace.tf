provider "kubernetes" {
  config_path    = pathexpand(var.kind_cluster_config_path)
  config_context = "kind-terraform"
}

data "kubernetes_resource" "sonarqube_ns" {
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name      = "sonarqube"
    namespace = "sonarqube"
  }
}