resource "kubernetes_manifest" "configmap_sonarqube_sonarqube_sonarqube_config" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "sonar.properties" = ""
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "annotations" = {
        "meta.helm.sh/release-name"      = "sonarqube"
        "meta.helm.sh/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app"                          = "sonarqube"
        "app.kubernetes.io/managed-by" = "Helm"
        "chart"                        = "sonarqube-8.0.1_546"
        "heritage"                     = "Helm"
        "release"                      = "sonarqube"
      }
      "name"      = "sonarqube-sonarqube-config"
      "namespace" = "sonarqube"
    }
  }
  depends_on = [ 
    kubernetes_namespace.sonarqube_ns
     ]
}

resource "kubernetes_manifest" "configmap_sonarqube_sonarqube_sonarqube_init_fs" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "init_fs.sh" = ""
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "annotations" = {
        "meta.helm.sh/release-name"      = "sonarqube"
        "meta.helm.sh/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app"                          = "sonarqube"
        "app.kubernetes.io/managed-by" = "Helm"
        "chart"                        = "sonarqube-8.0.1_546"
        "heritage"                     = "Helm"
        "release"                      = "sonarqube"
      }
      "name"      = "sonarqube-sonarqube-init-fs"
      "namespace" = "sonarqube"
    }
  }
  depends_on = [ 
    kubernetes_namespace.sonarqube_ns
     ]
}

resource "kubernetes_manifest" "configmap_sonarqube_sonarqube_sonarqube_init_sysctl" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "init_sysctl.sh" = <<-EOT
      if [[ "$(sysctl -n vm.max_map_count)" -lt 524288 ]]; then
        sysctl -w vm.max_map_count=524288
      fi
      if [[ "$(sysctl -n fs.file-max)" -lt 131072 ]]; then
        sysctl -w fs.file-max=131072
      fi
      if [[ "$(ulimit -n)" != "unlimited" ]]; then
        if [[ "$(ulimit -n)" -lt 131072 ]]; then
          echo "ulimit -n 131072"
          ulimit -n 131072
        fi
      fi
      if [[ "$(ulimit -u)" != "unlimited" ]]; then
        if [[ "$(ulimit -u)" -lt 8192 ]]; then
          echo "ulimit -u 8192"
          ulimit -u 8192
        fi
      fi
      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "annotations" = {
        "meta.helm.sh/release-name"      = "sonarqube"
        "meta.helm.sh/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app"                          = "sonarqube"
        "app.kubernetes.io/managed-by" = "Helm"
        "chart"                        = "sonarqube-8.0.1_546"
        "heritage"                     = "Helm"
        "release"                      = "sonarqube"
      }
      "name"      = "sonarqube-sonarqube-init-sysctl"
      "namespace" = "sonarqube"
    }
  }
  depends_on = [ 
    kubernetes_namespace.sonarqube_ns
     ]
}

resource "kubernetes_manifest" "configmap_sonarqube_sonarqube_sonarqube_install_plugins" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "install_plugins.sh" = ""
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "annotations" = {
        "meta.helm.sh/release-name"      = "sonarqube"
        "meta.helm.sh/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app"                          = "sonarqube"
        "app.kubernetes.io/managed-by" = "Helm"
        "chart"                        = "sonarqube-8.0.1_546"
        "heritage"                     = "Helm"
        "release"                      = "sonarqube"
      }
      "name"      = "sonarqube-sonarqube-install-plugins"
      "namespace" = "sonarqube"
    }
  }
  depends_on = [ 
    kubernetes_namespace.sonarqube_ns
     ]
}

resource "kubernetes_manifest" "configmap_sonarqube_sonarqube_sonarqube_jdbc_config" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "SONAR_JDBC_URL"      = "jdbc:postgresql://sonarqube-postgresql:5432/sonarDB"
      "SONAR_JDBC_USERNAME" = "sonarUser"
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "annotations" = {
        "meta.helm.sh/release-name"      = "sonarqube"
        "meta.helm.sh/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app"                          = "sonarqube"
        "app.kubernetes.io/managed-by" = "Helm"
        "chart"                        = "sonarqube-8.0.1_546"
        "heritage"                     = "Helm"
        "release"                      = "sonarqube"
      }
      "name"      = "sonarqube-sonarqube-jdbc-config"
      "namespace" = "sonarqube"
    }
  }
  depends_on = [ 
    kubernetes_namespace.sonarqube_ns
     ]
}

resource "kubernetes_manifest" "configmap_sonarqube_sonarqube_sonarqube_prometheus_ce_config" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "prometheus-ce-config.yaml" = <<-EOT
      rules:
      - pattern: .*
      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "annotations" = {
        "meta.helm.sh/release-name"      = "sonarqube"
        "meta.helm.sh/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app"                          = "sonarqube"
        "app.kubernetes.io/managed-by" = "Helm"
        "chart"                        = "sonarqube-8.0.1_546"
        "heritage"                     = "Helm"
        "release"                      = "sonarqube"
      }
      "name"      = "sonarqube-sonarqube-prometheus-ce-config"
      "namespace" = "sonarqube"
    }
  }
  depends_on = [ 
    kubernetes_namespace.sonarqube_ns
     ]
}

resource "kubernetes_manifest" "configmap_sonarqube_sonarqube_sonarqube_prometheus_config" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "prometheus-config.yaml" = <<-EOT
      rules:
      - pattern: .*
      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "annotations" = {
        "meta.helm.sh/release-name"      = "sonarqube"
        "meta.helm.sh/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app"                          = "sonarqube"
        "app.kubernetes.io/managed-by" = "Helm"
        "chart"                        = "sonarqube-8.0.1_546"
        "heritage"                     = "Helm"
        "release"                      = "sonarqube"
      }
      "name"      = "sonarqube-sonarqube-prometheus-config"
      "namespace" = "sonarqube"
    }
  }
  depends_on = [ 
    kubernetes_namespace.sonarqube_ns
     ]
}

resource "kubernetes_manifest" "configmap_sonarqube_sonarqube_sonarqube_tests" {
  manifest = {
    "apiVersion" = "v1"
    "data" = {
      "run.sh" = <<-EOT
      @test "Testing Sonarqube UI is accessible" {
        curl --connect-timeout 5 --retry 12 --retry-delay 1 --retry-max-time 60 sonarqube-sonarqube:9000/api/system/status
      }
      EOT
    }
    "kind" = "ConfigMap"
    "metadata" = {
      "annotations" = {
        "meta.helm.sh/release-name"      = "sonarqube"
        "meta.helm.sh/release-namespace" = "sonarqube"
      }
      "labels" = {
        "app"                          = "sonarqube"
        "app.kubernetes.io/managed-by" = "Helm"
        "chart"                        = "sonarqube-8.0.1_546"
        "heritage"                     = "Helm"
        "release"                      = "sonarqube"
      }
      "name"      = "sonarqube-sonarqube-tests"
      "namespace" = "sonarqube"
    }
  }
  depends_on = [ 
    kubernetes_namespace.sonarqube_ns
     ]
}