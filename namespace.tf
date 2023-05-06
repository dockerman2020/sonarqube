provider "kubernetes" {
  config_path    = pathexpand(var.kind_cluster_config_path)
  config_context = "kind-terraform"
}

resource "kubernetes_namespace" "sonarqube_ns" {
  metadata {
    annotations = {
      name = "sonarqube"
    }
    labels = {
      "kubernetes.io/metadata.name" = "sonarqube"
    }
    name = "sonarqube"
  }
}