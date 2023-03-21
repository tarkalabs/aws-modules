data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate  = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

resource "helm_release" "main" {
  name                = var.name
  description         = var.description
  timeout             = var.timeout
  devel               = var.devel
  atomic              = var.atomic

  reuse_values        = var.reuse_values
  reset_values        = var.reset_values
  force_update        = var.force_update
  recreate_pods       = var.recreate_pods
  cleanup_on_fail     = var.cleanup_on_fail

  wait                = var.wait
  wait_for_jobs       = var.wait_for_jobs
  values              = var.values

  verify              = var.verify
  keyring             = var.keyring

  max_history                = var.max_history
  skip_crds                  = var.skip_crds
  render_subchart_notes      = var.render_subchart_notes
  disable_openapi_validation = var.disable_openapi_validation

  chart                      = var.chart
  version                    = var.chart_version
  create_namespace           = var.create_namespace
  namespace                  = var.namespace
  repository                 = var.repository
  repository_username        = var.repository_username
  repository_password        = var.repository_password
  repository_key_file         = var.repository_key_file
  repository_cert_file        = var.repository_cert_file
  repository_ca_file          = var.repository_ca_file

  lint                       = var.lint
  disable_webhooks           = var.disable_webhooks
  dependency_update          = var.dependency_update
  pass_credentials           = var.pass_credentials

  dynamic "postrender" {
    for_each = var.postrender != null ? [1] : []
    content {
      binary_path  = var.postrender.binary_path
      args         = lookup(var.postrender, "args", null)
    }
  }

  dynamic "set" {
    for_each = length(var.settings) == 0 ? [] : var.settings
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  dynamic "set_sensitive" {
    # Hack to make for_each work
    for_each = length(var.settings_sensitive) == 0 ? [] : var.settings_sensitive
    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
      type  = lookup(set_sensitive.value, "type", null)
    }
  }
}
