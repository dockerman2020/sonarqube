# resource "kubernetes_manifest" "persistentvolumeclaim_sonarqube_data_sonarqube_postgresql_0" {
#   manifest = {
#     "apiVersion" = "v1"
#     "kind"       = "PersistentVolumeClaim"
#     "metadata" = {
#       "annotations" = {
#         "pv.kubernetes.io/bind-completed"               = "yes"
#         "pv.kubernetes.io/bound-by-controller"          = "yes"
#         "volume.beta.kubernetes.io/storage-provisioner" = "rancher.io/local-path"
#         "volume.kubernetes.io/storage-provisioner"      = "rancher.io/local-path"
#       }
#       "labels" = {
#         "app.kubernetes.io/instance" = "sonarqube"
#         "app.kubernetes.io/name"     = "postgresql"
#         "role"                       = "primary"
#       }
#       "name"      = "data-sonarqube-postgresql-0"
#       "namespace" = "sonarqube"
#     }
#     "spec" = {
#       "accessModes" = [
#         "ReadWriteOnce",
#       ]
#       "resources" = {
#         "requests" = {
#           "storage" = "20Gi"
#         }
#       }
#       "storageClassName" = "standard"
#       "volumeMode"       = "Filesystem"
#     }
#   }
#   depends_on = [ 
#     kubernetes_namespace.sonarqube_ns
#      ]
# }
resource "kubernetes_manifest" "persistentvolumeclaim_sonarqube_data_sonarqube_postgresql_0" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "PersistentVolumeClaim"
    "metadata" = {
      "name" = "data-sonarqube-postgresql-0"
      "namespace" = "sonarqube"
    }
    "spec" = {
      "accessModes" = [
        "ReadWriteOnce",
      ]
      "resources" = {
        "requests" = {
          "storage" = "20Gi"
        }
      }
      "storageClassName" = "local-storage"
    }
  }
  depends_on = [
     kubernetes_manifest.persistentvolume_sonarqube_pv_volume
     ]
}
