variable "eks_cluster_name" {
  type          = string
  description   = "EKS cluster name"
}

variable "yaml_content" {
  type          = string
  description   = "Kubernetes yaml manifest content"
}
