terraform {
  source      = "${get_path_to_repo_root()}//http_request"
}

inputs        = {
  url         = "https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.9/git-clone.yaml"
}
