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

provider "kubectl" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate  = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  load_config_file         = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.this.id]
  }
}

data "kubectl_file_documents" "this" {
  content = var.yaml_content
}

# Not possible to maintain order while creating resources with for_each or count.
# Because of execution order issues, kubernetes resources dependency issues may arise while running.
# Use manifests_local_exec module which uses kubectl apply for dependent manifests residing in a single file.
resource "kubectl_manifest" "this" {
  for_each  = data.kubectl_file_documents.this.manifests
  yaml_body = each.value
}
