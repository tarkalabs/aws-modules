terraform {
  source      = "${get_path_to_repo_root()}//http_request"
}

inputs        = {
  url         = "https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.46.0/release.yaml"
}
