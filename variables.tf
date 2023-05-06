variable "kind_cluster_config_path" {
  type        = string
  description = "The location where this cluster's kubeconfig will be saved to."
  default     = "~/.kube/config"
}

variable "app-name" {
  type        = string
  description = "The name of the app."
  default     = "sonarqube"
}
