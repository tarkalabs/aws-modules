terraform {
  source      = "${get_path_to_repo_root()}//http_request"
}

inputs        = {
  url         = "https://raw.githubusercontent.com/tektoncd/catalog/main/task/kubernetes-actions/0.2/kubernetes-actions.yaml"
}
