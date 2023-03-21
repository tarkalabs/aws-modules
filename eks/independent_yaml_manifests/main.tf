terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate  = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file         = false
}

data "kubectl_file_documents" "this" {
  content = var.yaml_content
}

# Not possible to maintain order while creating resources with for_each or count.
# Because of execution order issues, kubernetes resources dependency issues may arise while running.
# Use manifests_local_exec module which uses kubectl apply for dependent manifests residing in a single file.
resource "kubectl_manifest" "this" {
  for_each  = data.kubectl_file_documents.docs.manifests
  yaml_body = each.value
}
