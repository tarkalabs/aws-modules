data "http" "this" {
  url             = var.url
  method          = var.method
  insecure        = var.insecure
  ca_cert_pem     = var.ca_cert_pem
  request_body    = var.request_body
  request_headers = var.request_headers

  lifecycle {
    postcondition {
      condition     = contains(var.success_codes, self.status_code)
      error_message = "Recieved invalid status code - ${self.status_code}"
    }
  }
}
