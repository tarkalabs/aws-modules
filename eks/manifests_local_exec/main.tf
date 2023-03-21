data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

resource "local_file" "kubeconfig" {
  filename  = "${path.cwd}/kubeconfig.json"
  content = jsonencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "terraform"
    clusters    = [{
      name      = data.aws_eks_cluster.this.id
      cluster   = {
        certificate-authority-data  = data.aws_eks_cluster.this.certificate_authority.0.data
        server                     = data.aws_eks_cluster.this.endpoint
      }
    }]
    contexts    = [{
      name      = "terraform"
      context   = {
        cluster = data.aws_eks_cluster.this.id
        user    = "terraform"
      }
    }]
    users = [{
      name = "terraform"
      user = {
        token = data.aws_eks_cluster_auth.this.token
      }
    }]
  })
}

resource "local_file" "manifests" {
  filename  = "${path.cwd}/manifests.yaml"
  content  = var.yaml_content
}

resource "null_resource" "apply" {
  triggers      = {
    manifests_content  = local_file.manifests.content
    manifests_filename  = local_file.manifests.filename
    kubeconfig_filename  = local_file.kubeconfig.filename
  }
  provisioner "local-exec" {
    command     = "kubectl apply -f ${local_file.manifests.filename} --kubeconfig=${local_file.kubeconfig.filename}"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "kubectl delete -f ${self.triggers.manifests_filename} --kubeconfig=${self.triggers.kubeconfig_filename}"
    interpreter = ["/bin/bash", "-c"]
  }
}
