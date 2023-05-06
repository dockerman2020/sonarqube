# # apiVersion: v1
# # kind: Pod
# # metadata:
# #   name: "release-name-ui-test"
# #   annotations:
# #     "helm.sh/hook": test-success
# #   labels:
# #     app: sonarqube
# #     chart: sonarqube-8.0.1_546
# #     release: release-name
# #     heritage: Helm
# # spec:
# #   initContainers:
# #     - name: "bats"
# #       image: "bats/bats:1.2.1"
# #       imagePullPolicy: IfNotPresent
# #       command: ["bash", "-c"]
# #       args:
# #         - |-
# #           set -ex
# #           cp -R /opt/bats /tools/bats/
# #       resources:
# #         {}
# #       volumeMounts:
# #         - mountPath: /tools
# #           name: tools
# #   containers:
# #     - name: release-name-ui-test
# #       image: "bitnami/minideb-extras"
# #       imagePullPolicy: IfNotPresent
# #       command: [
# #         "/tools/bats/bin/bats",
# #         "--tap",
# #         "/tests/run.sh"]
# #       resources:
# #         {}
# #       volumeMounts:
# #       - mountPath: /tests
# #         name: tests
# #         readOnly: true
# #       - mountPath: /tools
# #         name: tools
# #   volumes:
# #   - name: tests
# #     configMap:
# #       name: release-name-sonarqube-tests
# #   - name: tools
# #     emptyDir:
# #       {}
# #   restartPolicy: Never

# resource "kubernetes_manifest" "pod_release_name_ui_test" {
#   manifest = {
#     "apiVersion" = "v1"
#     "kind" = "Pod"
#     "metadata" = {
#       "annotations" = {
#         "helm.sh/hook" = "test-success"
#       }
#       "labels" = {
#         "app" = "sonarqube"
#         "chart" = "sonarqube-8.0.1_546"
#         "heritage" = "Helm"
#         "release" = "release-name"
#       }
#       "name" = "release-name-ui-test"
#     }
#     "spec" = {
#       "containers" = [
#         {
#           "command" = [
#             "/tools/bats/bin/bats",
#             "--tap",
#             "/tests/run.sh",
#           ]
#           "image" = "bitnami/minideb-extras"
#           "imagePullPolicy" = "IfNotPresent"
#           "name" = "release-name-ui-test"
#           "resources" = {}
#           "volumeMounts" = [
#             {
#               "mountPath" = "/tests"
#               "name" = "tests"
#               "readOnly" = true
#             },
#             {
#               "mountPath" = "/tools"
#               "name" = "tools"
#             },
#           ]
#         },
#       ]
#       "initContainers" = [
#         {
#           "args" = [
#             <<-EOT
#             set -ex
#             cp -R /opt/bats /tools/bats/
#             EOT
#             ,
#           ]
#           "command" = [
#             "bash",
#             "-c",
#           ]
#           "image" = "bats/bats:1.2.1"
#           "imagePullPolicy" = "IfNotPresent"
#           "name" = "bats"
#           "resources" = {}
#           "volumeMounts" = [
#             {
#               "mountPath" = "/tools"
#               "name" = "tools"
#             },
#           ]
#         },
#       ]
#       "restartPolicy" = "Never"
#       "volumes" = [
#         {
#           "configMap" = {
#             "name" = "release-name-sonarqube-tests"
#           }
#           "name" = "tests"
#         },
#         {
#           "emptyDir" = {}
#           "name" = "tools"
#         },
#       ]
#     }
#   }
# }