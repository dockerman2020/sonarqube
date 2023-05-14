resource "kubernetes_manifest" "ingress_sonarqube_sonarqube_sonarqube" {
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind"       = "Ingress"
    "metadata" = {
      "annotations" = {
        "ingressClassName"                            = "nginx"
        "meta.kind.tf/release-name"                   = "sonarqube"
        "meta.kind.tf/release-namespace"              = "sonarqube"
        "nginx.ingress.kubernetes.io/proxy-body-size" = "64m"
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
      "rules" = [
        {
          "host" = "sonarqube.absi.test"
          "http" = {
            "paths" = [
              {
                "backend" = {
                  "service" = {
                    "name" = "sonarqube-sonarqube"
                    "port" = {
                      "number" = 9000
                    }
                  }
                }
                "path"     = "/"
                "pathType" = "ImplementationSpecific"
              },
            ]
          }
        },
      ]
    }
  }
  depends_on = [ 
    data.kubernetes_resource.sonarqube_ns
     ]
}