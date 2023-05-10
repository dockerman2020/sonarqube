resource "kubernetes_manifest" "statefulset_sonarqube_sonarqube_sonarqube" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "StatefulSet"
    "metadata" = {
      "annotations" = {
        "meta.kind.tf/release-name"      = data.kubernetes_resource.sonarqube_ns.metadata[0].name
        "meta.kind.tf/release-namespace" = data.kubernetes_resource.sonarqube_ns.metadata[0].namespace
      }
      "labels" = {
        "app"                          = "sonarqube"
        "app.kubernetes.io/component"  = "sonarqube-sonarqube"
        "app.kubernetes.io/instance"   = "sonarqube"
        "app.kubernetes.io/managed-by" = "Terraform"
        "app.kubernetes.io/name"       = "sonarqube-sonarqube-sonarqube"
        "app.kubernetes.io/part-of"    = "sonarqube"
        "app.kubernetes.io/version"    = "9.9.1-community"
        "chart"                        = "sonarqube-8.0.1_546"
        "heritage"                     = "Terraform"
        "release"                      = "sonarqube"
      }
      "name"      = "sonarqube-sonarqube"
      "namespace" = data.kubernetes_resource.sonarqube_ns.metadata[0].namespace
    }
    "spec" = {
      "persistentVolumeClaimRetentionPolicy" = {
        "whenDeleted" = "Retain"
        "whenScaled"  = "Retain"
      }
      "podManagementPolicy"  = "OrderedReady"
      "replicas"             = 1
      "revisionHistoryLimit" = 10
      "selector" = {
        "matchLabels" = {
          "app"     = "sonarqube"
          "release" = "sonarqube"
        }
      }
      "serviceName" = "sonarqube-sonarqube"
      "template" = {
        "metadata" = {
          "annotations" = {
            "checksum/config"               = "8c9be2e73dd982ff2e319692fc7629976c7cee76deb1f657e7b23d8f738f7262"
            "checksum/init-fs"              = "de425971490dddc7fabdf160d6beb70841bb7b9d3bb822444dbde0d0423f3e87"
            "checksum/init-sysctl"          = "ada9774e8ee1b666b5bad2ac34871e915a16ff7cf4ef1910362fa4895345f5b0"
            "checksum/plugins"              = "ca3485ae9c3dbfe13cc5b6cf18e78c0ca074ddae70d7eaf73fd027f04bf29c41"
            "checksum/prometheus-ce-config" = "764865c8ea550e52cb29abff97dccffa29070c40b81f42ffa49de2b7478b9787"
            "checksum/prometheus-config"    = "b8f580fb27d104fac41d0bee09c4426765c290b1e174f555761ad80de4870481"
            "checksum/secret"               = "20ebdc33b4f10d26c5fb5eeddf883d02cbc7b242732dc2651e00851e59ade35b"
          }
          "creationTimestamp" = null
          "labels" = {
            "app"     = "sonarqube"
            "release" = "sonarqube"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name"  = "SONAR_WEB_JAVAOPTS"
                  "value" = "-javaagent:/opt/sonarqube/data/jmx_prometheus_javaagent.jar=8000:/opt/sonarqube/conf/prometheus-config.yaml"
                },
                {
                  "name"  = "SONAR_CE_JAVAOPTS"
                  "value" = "-javaagent:/opt/sonarqube/data/jmx_prometheus_javaagent.jar=8001:/opt/sonarqube/conf/prometheus-ce-config.yaml"
                },
                {
                  "name" = "SONAR_JDBC_PASSWORD"
                  "valueFrom" = {
                    "secretKeyRef" = {
                      "key"  = "postgresql-password"
                      "name" = "sonarqube-postgresql"
                    }
                  }
                },
                {
                  "name" = "SONAR_WEB_SYSTEMPASSCODE"
                  "valueFrom" = {
                    "secretKeyRef" = {
                      "key"  = "SONAR_WEB_SYSTEMPASSCODE"
                      "name" = "sonarqube-sonarqube-monitoring-passcode"
                    }
                  }
                },
              ]
              "envFrom" = [
                {
                  "configMapRef" = {
                    "name" = "sonarqube-sonarqube-jdbc-config"
                  }
                },
              ]
              "image"           = "sonarqube:9.9.1-community"
              "imagePullPolicy" = "IfNotPresent"
              "livenessProbe" = {
                "exec" = {
                  "command" = [
                    "sh",
                    "-c",
                    <<-EOT
                    host="$(hostname -i || echo '127.0.0.1')"
                    reply=$(wget -qO- --header="X-Sonar-Passcode: $SONAR_WEB_SYSTEMPASSCODE" http://$${host}:9000/api/system/liveness 2>&1)
                    if [ -z "$reply" ]; then exit 0; else exit 1; fi

                    EOT
                    ,
                  ]
                }
                "failureThreshold"    = 6
                "initialDelaySeconds" = 60
                "periodSeconds"       = 30
                "successThreshold"    = 1
                "timeoutSeconds"      = 1
              }
              "name" = "sonarqube"
              "ports" = [
                {
                  "containerPort" = 9000
                  "name"          = "http"
                  "protocol"      = "TCP"
                },
                {
                  "containerPort" = 8000
                  "name"          = "monitoring-web"
                  "protocol"      = "TCP"
                },
                {
                  "containerPort" = 8001
                  "name"          = "monitoring-ce"
                  "protocol"      = "TCP"
                },
              ]
              "readinessProbe" = {
                "exec" = {
                  "command" = [
                    "sh",
                    "-c",
                    <<-EOT
                    #!/bin/bash
                    # A Sonarqube container is considered ready if the status is UP, DB_MIGRATION_NEEDED or DB_MIGRATION_RUNNING
                    # status about migration are added to prevent the node to be kill while sonarqube is upgrading the database.
                    host="$(hostname -i || echo '127.0.0.1')"
                    if wget --proxy off -qO- http://$${host}:9000/api/system/status | grep -q -e '"status":"UP"' -e '"status":"DB_MIGRATION_NEEDED"' -e '"status":"DB_MIGRATION_RUNNING"'; then
                    	exit 0
                    fi
                    exit 1

                    EOT
                    ,
                  ]
                }
                "failureThreshold"    = 6
                "initialDelaySeconds" = 60
                "periodSeconds"       = 30
                "successThreshold"    = 1
                "timeoutSeconds"      = 1
              }
              "resources" = {
                "limits" = {
                  "cpu"    = "800m"
                  "memory" = "4Gi"
                }
                "requests" = {
                  "cpu"    = "400m"
                  "memory" = "2Gi"
                }
              }
              "securityContext" = {
                "runAsUser" = 1000
              }
              "startupProbe" = {
                "failureThreshold" = 24
                "httpGet" = {
                  "path"   = "/api/system/status"
                  "port"   = "http"
                  "scheme" = "HTTP"
                }
                "initialDelaySeconds" = 30
                "periodSeconds"       = 10
                "successThreshold"    = 1
                "timeoutSeconds"      = 1
              }
              "terminationMessagePath"   = "/dev/termination-log"
              "terminationMessagePolicy" = "File"
              "volumeMounts" = [
                {
                  "mountPath" = "/opt/sonarqube/data"
                  "name"      = "sonarqube"
                  "subPath"   = "data"
                },
                {
                  "mountPath" = "/opt/sonarqube/temp"
                  "name"      = "sonarqube"
                  "subPath"   = "temp"
                },
                {
                  "mountPath" = "/opt/sonarqube/logs"
                  "name"      = "sonarqube"
                  "subPath"   = "logs"
                },
                {
                  "mountPath" = "/tmp"
                  "name"      = "tmp-dir"
                },
                {
                  "mountPath" = "/opt/sonarqube/conf/prometheus-config.yaml"
                  "name"      = "prometheus-config"
                  "subPath"   = "prometheus-config.yaml"
                },
                {
                  "mountPath" = "/opt/sonarqube/conf/prometheus-ce-config.yaml"
                  "name"      = "prometheus-ce-config"
                  "subPath"   = "prometheus-ce-config.yaml"
                },
              ]
            },
          ]
          "dnsPolicy" = "ClusterFirst"
          "initContainers" = [
            {
              "command" = [
                "/bin/sh",
                "-c",
                "for i in $(seq 1 200); do nc -z -w3 sonarqube-postgresql 5432 && exit 0 || sleep 2; done; exit 1",
              ]
              "image"                    = "busybox:1.32"
              "imagePullPolicy"          = "IfNotPresent"
              "name"                     = "wait-for-db"
              "resources"                = {}
              "terminationMessagePath"   = "/dev/termination-log"
              "terminationMessagePolicy" = "File"
            },
            {
              "command" = [
                "sh",
                "-e",
                "/tmp/scripts/init_sysctl.sh",
              ]
              "image"           = "busybox:1.32"
              "imagePullPolicy" = "IfNotPresent"
              "name"            = "init-sysctl"
              "resources"       = {}
              "securityContext" = {
                "privileged" = true
              }
              "terminationMessagePath"   = "/dev/termination-log"
              "terminationMessagePolicy" = "File"
              "volumeMounts" = [
                {
                  "mountPath" = "/tmp/scripts/"
                  "name"      = "init-sysctl"
                },
              ]
            },
            {
              "args" = [
                "curl -s 'https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.16.0/jmx_prometheus_javaagent-0.16.0.jar'  --output /data/jmx_prometheus_javaagent.jar -v",
              ]
              "command" = [
                "/bin/sh",
                "-c",
              ]
              "env" = [
                {
                  "name" = "http_proxy"
                },
                {
                  "name" = "https_proxy"
                },
                {
                  "name" = "no_proxy"
                },
              ]
              "image"           = "curlimages/curl:7.76.1"
              "imagePullPolicy" = "IfNotPresent"
              "name"            = "inject-prometheus-exporter"
              "resources"       = {}
              "securityContext" = {
                "runAsGroup" = 1000
                "runAsUser"  = 1000
              }
              "terminationMessagePath"   = "/dev/termination-log"
              "terminationMessagePolicy" = "File"
              "volumeMounts" = [
                {
                  "mountPath" = "/data"
                  "name"      = "sonarqube"
                  "subPath"   = "data"
                },
              ]
            },
          ]
          "restartPolicy" = "Always"
          "schedulerName" = "default-scheduler"
          "securityContext" = {
            "fsGroup" = 1000
          }
          "serviceAccount"                = "default"
          "serviceAccountName"            = "default"
          "terminationGracePeriodSeconds" = 30
          "volumes" = [
            {
              "configMap" = {
                "defaultMode" = 420
                "items" = [
                  {
                    "key"  = "init_sysctl.sh"
                    "path" = "init_sysctl.sh"
                  },
                ]
                "name" = "sonarqube-sonarqube-init-sysctl"
              }
              "name" = "init-sysctl"
            },
            {
              "configMap" = {
                "defaultMode" = 420
                "items" = [
                  {
                    "key"  = "init_fs.sh"
                    "path" = "init_fs.sh"
                  },
                ]
                "name" = "sonarqube-sonarqube-init-fs"
              }
              "name" = "init-fs"
            },
            {
              "configMap" = {
                "defaultMode" = 420
                "items" = [
                  {
                    "key"  = "install_plugins.sh"
                    "path" = "install_plugins.sh"
                  },
                ]
                "name" = "sonarqube-sonarqube-install-plugins"
              }
              "name" = "install-plugins"
            },
            {
              "configMap" = {
                "defaultMode" = 420
                "items" = [
                  {
                    "key"  = "prometheus-config.yaml"
                    "path" = "prometheus-config.yaml"
                  },
                ]
                "name" = "sonarqube-sonarqube-prometheus-config"
              }
              "name" = "prometheus-config"
            },
            {
              "configMap" = {
                "defaultMode" = 420
                "items" = [
                  {
                    "key"  = "prometheus-ce-config.yaml"
                    "path" = "prometheus-ce-config.yaml"
                  },
                ]
                "name" = "sonarqube-sonarqube-prometheus-ce-config"
              }
              "name" = "prometheus-ce-config"
            },
            {
              "emptyDir" = {}
              "name"     = "sonarqube"
            },
            {
              "emptyDir" = {}
              "name"     = "tmp-dir"
            },
          ]
        }
      }
      "updateStrategy" = {
        "rollingUpdate" = {
          "partition" = 0
        }
        "type" = "RollingUpdate"
      }
    }
  }
  depends_on = [ 
    data.kubernetes_resource.sonarqube_ns
   ]
}

resource "kubernetes_manifest" "statefulset_sonarqube_sonarqube_postgresql" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "StatefulSet"
    "metadata" = {
      "annotations" = {
        "meta.kind.tf/release-name"      = data.kubernetes_resource.sonarqube_ns.metadata[0].name
        "meta.kind.tf/release-namespace" = data.kubernetes_resource.sonarqube_ns.metadata[0].namespace
      }
      "labels" = {
        "app.kubernetes.io/component" = "primary"
        "app.kubernetes.io/instance"  = "sonarqube"
        "app.kubernetes.io/name"      = "postgresql"
      }
      "name"      = "sonarqube-postgresql"
      "namespace" = data.kubernetes_resource.sonarqube_ns.metadata[0].namespace
    }
    "spec" = {
      "persistentVolumeClaimRetentionPolicy" = {
        "whenDeleted" = "Retain"
        "whenScaled"  = "Retain"
      }
      "podManagementPolicy"  = "OrderedReady"
      "replicas"             = 1
      "revisionHistoryLimit" = 10
      "selector" = {
        "matchLabels" = {
          "app.kubernetes.io/instance" = "sonarqube"
          "app.kubernetes.io/name"     = "postgresql"
          "role"                       = "primary"
        }
      }
      "serviceName" = "sonarqube-postgresql-headless"
      "template" = {
        "metadata" = {
          "labels" = {
            "app.kubernetes.io/component" = "primary"
            "app.kubernetes.io/instance"  = "sonarqube"
            "app.kubernetes.io/name"      = "postgresql"
            "role"                        = "primary"
          }
          "name" = "sonarqube-postgresql"
        }
        "spec" = {
          "affinity" = {
            "podAntiAffinity" = {
              "preferredDuringSchedulingIgnoredDuringExecution" = [
                {
                  "podAffinityTerm" = {
                    "labelSelector" = {
                      "matchLabels" = {
                        "app.kubernetes.io/component" = "primary"
                        "app.kubernetes.io/instance"  = "sonarqube"
                        "app.kubernetes.io/name"      = "postgresql"
                      }
                    }
                    "namespaces" = [
                      "sonarqube",
                    ]
                    "topologyKey" = "kubernetes.io/hostname"
                  }
                  "weight" = 1
                },
              ]
            }
          }
          "automountServiceAccountToken" = false
          "containers" = [
            {
              "env" = [
                {
                  "name"  = "BITNAMI_DEBUG"
                  "value" = "false"
                },
                {
                  "name"  = "POSTGRESQL_PORT_NUMBER"
                  "value" = "5432"
                },
                {
                  "name"  = "POSTGRESQL_VOLUME_DIR"
                  "value" = "/bitnami/postgresql"
                },
                {
                  "name"  = "PGDATA"
                  "value" = "/bitnami/postgresql/data"
                },
                {
                  "name" = "POSTGRES_POSTGRES_PASSWORD"
                  "valueFrom" = {
                    "secretKeyRef" = {
                      "key"  = "postgresql-postgres-password"
                      "name" = "sonarqube-postgresql"
                    }
                  }
                },
                {
                  "name"  = "POSTGRES_USER"
                  "value" = "sonarUser"
                },
                {
                  "name" = "POSTGRES_PASSWORD"
                  "valueFrom" = {
                    "secretKeyRef" = {
                      "key"  = "postgresql-password"
                      "name" = "sonarqube-postgresql"
                    }
                  }
                },
                {
                  "name"  = "POSTGRES_DB"
                  "value" = "sonarDB"
                },
                {
                  "name"  = "POSTGRESQL_ENABLE_LDAP"
                  "value" = "no"
                },
                {
                  "name"  = "POSTGRESQL_ENABLE_TLS"
                  "value" = "no"
                },
                {
                  "name"  = "POSTGRESQL_LOG_HOSTNAME"
                  "value" = "false"
                },
                {
                  "name"  = "POSTGRESQL_LOG_CONNECTIONS"
                  "value" = "false"
                },
                {
                  "name"  = "POSTGRESQL_LOG_DISCONNECTIONS"
                  "value" = "false"
                },
                {
                  "name"  = "POSTGRESQL_PGAUDIT_LOG_CATALOG"
                  "value" = "off"
                },
                {
                  "name"  = "POSTGRESQL_CLIENT_MIN_MESSAGES"
                  "value" = "error"
                },
                {
                  "name"  = "POSTGRESQL_SHARED_PRELOAD_LIBRARIES"
                  "value" = "pgaudit"
                },
              ]
              "image"           = "docker.io/bitnami/postgresql:11.14.0-debian-10-r22"
              "imagePullPolicy" = "IfNotPresent"
              "livenessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/sh",
                    "-c",
                    "exec pg_isready -U \"sonarUser\" -d \"dbname=sonarDB\" -h 127.0.0.1 -p 5432",
                  ]
                }
                "failureThreshold"    = 6
                "initialDelaySeconds" = 30
                "periodSeconds"       = 10
                "successThreshold"    = 1
                "timeoutSeconds"      = 5
              }
              "name" = "sonarqube-postgresql"
              "ports" = [
                {
                  "containerPort" = 5432
                  "name"          = "tcp-postgresql"
                  "protocol"      = "TCP"
                },
              ]
              "readinessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/sh",
                    "-c",
                    "-e",
                    <<-EOT
                    exec pg_isready -U "sonarUser" -d "dbname=sonarDB" -h 127.0.0.1 -p 5432
                    [ -f /opt/bitnami/postgresql/tmp/.initialized ] || [ -f /bitnami/postgresql/.initialized ]

                    EOT
                    ,
                  ]
                }
                "failureThreshold"    = 6
                "initialDelaySeconds" = 5
                "periodSeconds"       = 10
                "successThreshold"    = 1
                "timeoutSeconds"      = 5
              }
              "resources" = {
                "limits" = {
                  "cpu"    = "2"
                  "memory" = "2Gi"
                }
                "requests" = {
                  "cpu"    = "100m"
                  "memory" = "200Mi"
                }
              }
              "securityContext" = {
                "runAsUser" = 1001
              }
              "terminationMessagePath"   = "/dev/termination-log"
              "terminationMessagePolicy" = "File"
              "volumeMounts" = [
                {
                  "mountPath" = "/dev/shm"
                  "name"      = "dshm"
                },
                {
                  "mountPath" = "/bitnami/postgresql"
                  "name"      = "data"
                },
              ]
            },
          ]
          "dnsPolicy"     = "ClusterFirst"
          "restartPolicy" = "Always"
          "schedulerName" = "default-scheduler"
          "securityContext" = {
            "fsGroup" = 1001
          }
          "terminationGracePeriodSeconds" = 30
          "volumes" = [
            {
              "emptyDir" = {
                "medium" = "Memory"
              }
              "name" = "dshm"
            },
            {
              "name" = "data"
              "persistentVolumeClaim" = {
                "claimName" = "data-sonarqube-postgresql-0"
              }
            },
          ]
        }
      }
      "updateStrategy" = {
        "type" = "RollingUpdate"
      }
      # "volumeClaimTemplates" = [
      #   {
      #     "apiVersion" = "v1"
      #     "kind"       = "PersistentVolumeClaim"
      #     "metadata" = {
      #       "name" = "data"
      #     }
      #     "spec" = {
      #       "accessModes" = [
      #         "ReadWriteOnce",
      #       ]
      #       "storageClassName" = "local-storage"
      #       "resources" = {
      #         "requests" = {
      #           "storage" = "20Gi"
      #         }
      #       }
      #       "volumeMode" = "Filesystem"
      #     }
      #   },
      # ]
    }
  }
  depends_on = [ 
    kubernetes_manifest.persistentvolumeclaim_sonarqube_data_sonarqube_postgresql_0
   ]
}
