variable "url" {
  type        = string
  description = "The URL for the request. Supported schemes are http and https."
}

variable "ca_cert_pem" {
  type        = string
  description = "Certificate data of the Certificate Authority (CA) in PEM (RFC 1421) format."
  default     = null
}

variable "insecure" {
  type        = string
  description = "Disables verification of the server's certificate chain and hostname. Defaults to `false`."
  default     = false
}

variable "method" {
  type        = string
  description = "The HTTP Method for the request. Allowed methods are a subset of methods defined in RFC7231 namely, GET, HEAD, and POST. POST support is only intended for read-only URLs, such as submitting a search."
  default     = "GET"
}

variable "request_body" {
  type        = string
  description = "The request body as a string."
  default     = null
}

variable "request_headers" {
  type        = map(string)
  description = "A map of request header field names and values."
  default     = null
}

variable "success_codes" {
  type        = list(number)
  description = "Http status codes to say request was successful. Default's to `[200]`."
  default     = [200]
}
