output "manifests_file_path" {
  value = local_file.manifests.filename
}

output "kubeconf_file_path" {
  value = local_file.kubeconfig.filename
}
