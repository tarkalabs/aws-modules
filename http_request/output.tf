output "id" {
  value = data.http.this.id
}

output "response_body" {
  value = data.http.this.response_body
}

output "response_headers" {
  value = data.http.this.response_headers
}

output "status_code" {
  value = data.http.this.status_code
}
