resource "kubernetes_manifest" "service_sonarqube_sonarqube_postgresql" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "annotations" = {
        "meta.kind.tf/release-name"      = "sonarqube"
        "meta.kind.tf/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app.kubernetes.io/instance"   = "sonarqube"
        "app.kubernetes.io/managed-by" = "Terraform"
        "app.kubernetes.io/name"       = "postgresql"
        "kind.tf/chart"                = "postgresql-10.15.0"
      }
      "name"      = "sonarqube-postgresql"
      "namespace" = "sonarqube"
    }
    "spec" = {
      "internalTrafficPolicy" = "Cluster"
      "ipFamilies" = [
        "IPv4",
      ]
      "ipFamilyPolicy" = "SingleStack"
      "ports" = [
        {
          "name"       = "tcp-postgresql"
          "port"       = 5432
          "protocol"   = "TCP"
          "targetPort" = "tcp-postgresql"
        },
      ]
      "selector" = {
        "app.kubernetes.io/instance" = "sonarqube"
        "app.kubernetes.io/name"     = "postgresql"
        "role"                       = "primary"
      }
      "sessionAffinity" = "None"
      "type"            = "ClusterIP"
    }
  }
  depends_on = [ 
    data.kubernetes_resource.sonarqube_ns
     ]
}

resource "kubernetes_manifest" "service_sonarqube_sonarqube_postgresql_headless" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "annotations" = {
        "meta.kind.tf/release-name"      = "sonarqube"
        "meta.kind.tf/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app.kubernetes.io/instance"                             = "sonarqube"
        "app.kubernetes.io/managed-by"                           = "Helm"
        "app.kubernetes.io/name"                                 = "postgresql"
        "kind.tf/chart"                                          = "postgresql-10.15.0"
        "service.alpha.kubernetes.io/tolerate-unready-endpoints" = "true"
      }
      "name"      = "sonarqube-postgresql-headless"
      "namespace" = "sonarqube"
    }
    "spec" = {
      "clusterIP" = "None"
      "clusterIPs" = [
        "None",
      ]
      "internalTrafficPolicy" = "Cluster"
      "ipFamilies" = [
        "IPv4",
      ]
      "ipFamilyPolicy" = "SingleStack"
      "ports" = [
        {
          "name"       = "tcp-postgresql"
          "port"       = 5432
          "protocol"   = "TCP"
          "targetPort" = "tcp-postgresql"
        },
      ]
      "publishNotReadyAddresses" = true
      "selector" = {
        "app.kubernetes.io/instance" = "sonarqube"
        "app.kubernetes.io/name"     = "postgresql"
      }
      "sessionAffinity" = "None"
      "type"            = "ClusterIP"
    }
  }
  depends_on = [ 
    data.kubernetes_resource.sonarqube_ns
     ]
}

resource "kubernetes_manifest" "service_sonarqube_sonarqube_sonarqube" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "annotations" = {
        "meta.kind.tf/release-name"      = "sonarqube"
        "meta.kind.tf/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app"                          = "sonarqube"
        "app.kubernetes.io/managed-by" = "Terraform"
        "chart"                        = "sonarqube-8.0.1_546"
        "heritage"                     = "Helm"
        "release"                      = "sonarqube"
      }
      "name"      = "sonarqube-sonarqube"
      "namespace" = "sonarqube"
    }
    "spec" = {
      "internalTrafficPolicy" = "Cluster"
      "ipFamilies" = [
        "IPv4",
      ]
      "ipFamilyPolicy" = "SingleStack"
      "ports" = [
        {
          "name"       = "http"
          "port"       = 9000
          "protocol"   = "TCP"
          "targetPort" = "http"
        },
      ]
      "selector" = {
        "app"     = "sonarqube"
        "release" = "sonarqube"
      }
      "sessionAffinity" = "None"
      "type"            = "ClusterIP"
    }
  }
  depends_on = [ 
   data.kubernetes_resource.sonarqube_ns
     ]
}

resource "kubernetes_manifest" "service_sonarqube_nodeport_server" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "annotations" = {
        "meta.kind.tf/release-name"      = "sonarqube"
        "meta.kind.tf/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app" = "sonarqube"
        "release" = "sonarqube"
      }
      "name" = "sonarqube-server-nodeport"
      "namespace" = "sonarqube"
    }
    "spec" = {
      "externalTrafficPolicy" = "Cluster"
      "internalTrafficPolicy" = "Cluster"
      "ipFamilies" = [
        "IPv4",
      ]
      "ipFamilyPolicy" = "SingleStack"
      "ports" = [
        {
          "name"       = "http"
          "port"       = 9000
          "nodePort" = 31923
          "protocol"   = "TCP"
          "targetPort" = "http"
        },
      ]
      "selector" = {
        "app"     = "sonarqube"
        "release" = "sonarqube"
      }
      "sessionAffinity" = "None"
      "type" = "NodePort"
    }
  }
}