locals {
  namespace = var.namespace != "" ? "-n ${var.namespace}" : ""
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
    manifests_content  = var.yaml_content
    manifests_filename  = "${path.cwd}/manifests.yaml"
    namespace          = local.namespace
  }

  provisioner "local-exec" {
    command     = <<EOA
cat >${self.triggers.manifests_filename} <<EOB
${self.triggers.manifests_content}
EOB
    EOA
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "kubectl apply ${local.namespace} -f ${self.triggers.manifests_filename}"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "kubectl delete --ignore-not-found=true ${self.triggers.namespace} -f ${self.triggers.manifests_filename}"
    interpreter = ["/bin/bash", "-c"]
  }
}
