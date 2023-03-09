resource "aws_s3_bucket" "main" {
  bucket  = var.name
  tags    = var.tags
}

resource "aws_s3_bucket_acl" "acl" {
  bucket  = aws_s3_bucket.main.id
  acl     = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket  = aws_s3_bucket.main.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}
