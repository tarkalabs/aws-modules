locals {
  namespace = var.namespace != "" ? "-n ${var.namespace}" : ""
}

resource "local_file" "manifests" {
  filename  = "${path.cwd}/manifests.yaml"
  content  = var.yaml_content
}

resource "null_resource" "this" {
  triggers      = {
    manifests_content  = local_file.manifests.content
    manifests_filename  = local_file.manifests.filename
    namespace          = var.namespace
  }

  provisioner "local-exec" {
    command     = "aws eks update-kubeconfig --region ${var.eks_cluster_region} --name ${var.eks_cluster_name}"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "kubectl apply ${local.namespace} -f ${local_file.manifests.filename}"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "kubectl delete -f ${self.triggers.manifests_filename}"
    interpreter = ["/bin/bash", "-c"]
  }
}
