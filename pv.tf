resource "kubernetes_manifest" "persistentvolume_sonarqube_pv_volume" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "PersistentVolume"
    "metadata" = {
      "labels" = {
        "type" = "local"
      }
      "name" = "sonarqube-pv-volume"
    }
    "spec" = {
      "accessModes" = [
        "ReadWriteOnce",
      ]
      "capacity" = {
        "storage" = "20Gi"
      }
      "claimRef" = {
        "name" = "data-sonarqube-postgresql-0"
        "namespace" = "sonarqube"
      }
      "local" = {
        "path" = "/ContainerData/SonarQube"
      }
      "nodeAffinity" = {
        "required" = {
          "nodeSelectorTerms" = [
            {
              "matchExpressions" = [
                {
                  "key" = "kubernetes.io/hostname"
                  "operator" = "In"
                  "values" = [
                    "terraform-worker",
                    "terraform-worker2",
                    "terraform-worker3",
                  ]
                },
              ]
            },
          ]
        }
      }
      "storageClassName" = "local-storage"
    }
  }
}