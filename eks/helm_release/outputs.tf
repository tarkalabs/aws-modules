output "manifest" {
  description = "The rendered manifest of the release as JSON. Enable the `manifest` experiment to use this feature"
  value = helm_release.main.manifest
}

output "metadata" {
  description = "Block status of the deployed release"
  value = helm_release.main.metadata
}

output "chart" {
  description = "The name of the chart"
  value = helm_release.main.metadata.0.chart
}

output "name" {
  description = "Name is the name of the release"
  value = helm_release.main.metadata.0.name
}

output "namespace" {
  description = "Namespace is the kubernetes namespace of the release"
  value = helm_release.main.metadata.0.namespace
}

output "revision" {
  description = "Version is an int32 which represents the version of the release"
  value = helm_release.main.metadata.0.revision
}

output "version" {
  description = "A SemVer 2 conformant version string of the chart"
  value = helm_release.main.metadata.0.version
}

output "app_version" {
  description = "The version number of the application being deployed"
  value = helm_release.main.metadata.0.app_version
}

output "values" {
  description = "The compounded values from `values` and `set*` attributes"
  value = helm_release.main.metadata.0.values
}
