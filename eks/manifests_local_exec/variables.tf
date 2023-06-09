variable "eks_cluster_name" {
  type          = string
  description   = "EKS cluster name"
}

variable "eks_cluster_region" {
  type          = string
  description   = "EKS cluster region"
  default       = "us-east-1"
}

variable "namespace" {
  type          = string
  description   = "Kubernetes namespace to be used to run kubectl against."
  default       = ""
}

variable "yaml_content" {
  type          = string
  description   = "Kubernetes yaml manifest content"
}
