variable "name" {
  type          = string
  description   = "Release name"
}

variable "eks_cluster_name" {
  type          = string
  description   = "EKS cluster name"
}

variable "description" {
  type          = string
  description   = "Set release description attribute (visible in the history)"
  default       = null
}

variable "chart" {
  type          = string
  description   = "Chart name to be installed. The chart name can be local path, a URL to a chart, or the name of the chart if `repository` is specified. It is also possible to use the `<repository>/<chart>` format here if you are running Terraform on a system that the repository has been added to with `helm repo add` but this is not recommended."
}

variable "repository" {
  type          = string
  description   = "Repository URL where to locate the requested chart"
  default       = null
}

variable "repository_key_file" {
  type          = string
  description   = "The repositories cert key file"
  default       = null
}

variable "repository_cert_file" {
  type          = string
  description   = "The repositories cert file"
  default       = null
}

variable "repository_ca_file" {
  type          = string
  description   = "The Repositories CA File"
  default       = null
}

variable "repository_username" {
  type          = string
  description   = "Username for HTTP basic authentication against the repository"
  default       = null
}

variable "repository_password" {
  type          = string
  description   = "Password for HTTP basic authentication against the repository"
  default       = null
}

variable "devel" {
  type          = string
  description   = "Specify the exact chart version to install. If this is not specified, the latest version is installed. helm_release will not automatically grab the latest release, version must explicitly upgraded when upgrading an installed chart."
  default       = null
}

variable "create_namespace" {
  type          = bool
  description   = "Create the namespace if it does not yet exist. Defaults to `false`."
  default       = false
}

variable "namespace" {
  type          = string
  description   = "The namespace to install the release into. Defaults to `default`."
  default       = null
}

variable "chart_version" {
  type          = string
  description   = "Specify the exact chart version to install. If this is not specified, the latest version is installed. `helm_release` will not automatically grab the latest release, version must explicitly upgraded when upgrading an installed chart."
  default       = null
}

variable "verify" {
  type          = bool
  description   = "Verify the package before installing it. Helm uses a provenance file to verify the integrity of the chart; this must be hosted alongside the chart. Defaults to `false`."
  default       = false
}

variable "keyring" {
  type          = string
  description   = "Location of public keys used for verification. Used only if `verify` is true. Defaults to `/.gnupg/pubring.gpg` in the location set by `home`."
  default       = null
}

variable "timeout" {
  type          = number
  description   = "Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks). Defaults to `300` seconds."
  default       = 300
}

variable "disable_webhooks" {
  type          = bool
  description   = "Prevent hooks from running. Defaults to `false`."
  default       = false
}

variable "reuse_values" {
  type          = bool
  description   = "When upgrading, reuse the last release's values and merge in any overrides. If 'reset_values' is specified, this is ignored. Defaults to `false`."
  default       = false
}

variable "reset_values" {
  type          = bool
  description   = "When upgrading, reset the values to the ones built into the chart. Defaults to `false`."
  default       = false
}

variable "force_update" {
  type          = bool
  description   = "Force resource update through delete/recreate if needed. Defaults to `false`."
  default       = false
}

variable "recreate_pods" {
  type          = bool
  description   = "Perform pods restart during upgrade/rollback. Defaults to `false`."
  default       = false
}

variable "cleanup_on_fail" {
  type          = bool
  description   = "Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to `false`."
  default       = false
}

variable "max_history" {
  type          = number
  description   = "Maximum number of release versions stored per release. Defaults to `0` (no limit)."
  default       = null
}

variable "atomic" {
  type          = bool
  description   = "If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to `false`."
  default       = false
}

variable "skip_crds" {
  type          = bool
  description   = "If set, no CRDs will be installed. By default, CRDs are installed if not already present. Defaults to false. `false`."
  default       = false
}

variable "render_subchart_notes" {
  type          = bool
  description   = "If set, render subchart notes along with the parent. Defaults to `true`."
  default       = true
}

variable "disable_openapi_validation" {
  type          = bool
  description   = "If set, the installation process will not validate rendered templates against the Kubernetes OpenAPI Schema. Defaults to `false`."
  default       = false
}

variable "wait" {
  type          = bool
  description   = "Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as timeout. Defaults to `true`."
  default       = false
}

variable "wait_for_jobs" {
  type          = bool
  description   = "If wait is enabled, will wait until all Jobs have been completed before marking the release as successful. It will wait for as long as timeout. Defaults to `false`."
  default       = false
}

variable "values" {
  type          = list(any)
  description   = "List of values in raw yaml to pass to helm. Values will be merged, in order, as Helm does with multiple `-f` options."
  default       = null
}

variable "settings" {
  type          = list(map(string))
  description   = "List of values in raw yaml to pass to helm. Values will be merged, in order, as Helm does with multiple `-f` options."
  default       = []
}

variable "settings_sensitive" {
  type          = list(map(string))
  description   = "Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff."
  default       = []
  sensitive     = true
}

variable "dependency_update" {
  type          = bool
  description   = "Runs helm dependency update before installing the chart. Defaults to `false`."
  default       = false
}

variable "replace" {
  type          = bool
  description   = "Re-use the given name, only if that name is a deleted release which remains in the history. This is unsafe in production. Defaults to `false`."
  default       = false
}

variable "postrender" {
  type          = map(string)
  description   = "Configure a command to run after helm renders the manifest which can alter the manifest contents."
  default       = null
}

variable "pass_credentials" {
  type          = bool
  description   = "Pass credentials to all domains. Defaults to `false`."
  default       = false
}

variable "lint" {
  type          = bool
  description   = "Run the helm chart linter during the plan. Defaults to `false`."
  default       = false
}
