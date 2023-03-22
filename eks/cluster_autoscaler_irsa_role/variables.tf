variable "eks_cluster_name" {
  type          = string
  description   = "EKS cluster name"
}

variable "oidc_provider_arn" {
  type          = string
  description   = "EKS cluster oidc provider arn"
}

variable "namespace_service_accounts" {
  type          = list(string)
  description   = "Namespace service accounts to attach to role"
  default       = ["kube-system:cluster-autoscaler"]
}

variable "tags" {
  description   = "A map of tags to add to all resources"
  type          = map(string)
  default       = {}
}
