locals {
  namespace = var.namespace != "" ? "-n ${var.namespace}" : ""
}

resource "local_file" "manifests" {
  filename  = "${path.cwd}/manifests.yaml"
  content  = var.yaml_content
}

resource "null_resource" "update-kubeconfig" {
  triggers      = {
    # Runs `aws eks update-kubeconfig` everytime so that we won't face authorization issues
    always_run         = timestamp()
  }

  provisioner "local-exec" {
    command     = "aws eks update-kubeconfig --region ${var.eks_cluster_region} --name ${var.eks_cluster_name}"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "this" {
  depends_on    = [ null_resource.update-kubeconfig ]
  triggers      = {
    manifests_content  = local_file.manifests.content
    manifests_filename  = local_file.manifests.filename
    namespace          = local.namespace
  }

  provisioner "local-exec" {
    command     = "kubectl apply ${local.namespace} -f ${local_file.manifests.filename}"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "kubectl delete --ignore-not-found=true -n ${self.triggers.namespace} -f ${self.triggers.manifests_filename}"
    interpreter = ["/bin/bash", "-c"]
  }
}
