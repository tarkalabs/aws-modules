terraform {
  source      = "${get_path_to_repo_root()}//http_request"
}

inputs        = {
  url         = "https://storage.googleapis.com/tekton-releases/triggers/previous/v0.23.0/interceptors.yaml"
}
