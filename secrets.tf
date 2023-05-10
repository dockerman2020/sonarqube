resource "kubernetes_manifest" "secret_sonarqube_sonarqube_postgresql" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "postgresql-password"          = "c29uYXJQYXNz"
      "postgresql-postgres-password" = "MnlwaHJ6VDltVQ=="
    }
    "kind" = "Secret"
    "metadata" = {
      "annotations" = {
        "meta.kind.tf/release-name"      = "sonarqube"
        "meta.kind.tf/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app.kubernetes.io/instance"   = "sonarqube"
        "app.kubernetes.io/managed-by" = "Helm"
        "app.kubernetes.io/name"       = "postgresql"
        "helm.sh/chart"                = "postgresql-10.15.0"
      }
      "name"      = "sonarqube-postgresql"
      "namespace" = "sonarqube"
    }
    "type" = "Opaque"
  }
  depends_on = [ 
    data.kubernetes_resource.sonarqube_ns
     ]
}

resource "kubernetes_manifest" "secret_sonarqube_sonarqube_sonarqube_monitoring_passcode" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "SONAR_WEB_SYSTEMPASSCODE" = "ZGVmaW5lX2l0"
    }
    "kind" = "Secret"
    "metadata" = {
      "annotations" = {
        "meta.kind.tf/release-name"      = "sonarqube"
        "meta.kind.tf/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app"                          = "sonarqube"
        "app.kubernetes.io/managed-by" = "Helm"
        "chart"                        = "sonarqube-8.0.1_546"
        "heritage"                     = "Helm"
        "release"                      = "sonarqube"
      }
      "name"      = "sonarqube-sonarqube-monitoring-passcode"
      "namespace" = "sonarqube"
    }
    "type" = "Opaque"
  }
  depends_on = [ 
    data.kubernetes_resource.sonarqube_ns
     ]
}
