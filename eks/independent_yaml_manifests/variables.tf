variable "eks_cluster_name" {
  type          = string
  description   = "EKS cluster name"
}

variable "yaml_content" {
  type          = string
  description   = "Required. YAML to apply to kubernetes."
}

variable "override_namespace" {
  type          = string
  description   = "Optional. Override the namespace to apply the kubernetes resource to, ignoring any declared namespace in the `yaml_body`."
  default       = null
}
