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
  default       = ["kube-system:external-dns"]
}

variable "hosted_zone_arns" {
  type          = list(string)
  description   = "Route53 hosted zone ARNs to allow External DNS to manage records"
  default       = ["arn:aws:route53:::hostedzone/*"]
}

variable "fetch_hosted_zones" {
  type          = bool
  description   = "Route53 hosted zones fetch using details"
  default       = false
}

variable "hosted_zone_details" {
  type          = list(map(string))
  description   = "Route53 hosted zone domain details to fetch their arns"
  default       = []
}

variable "tags" {
  description   = "A map of tags to add to all resources"
  type          = map(string)
  default       = {}
}
