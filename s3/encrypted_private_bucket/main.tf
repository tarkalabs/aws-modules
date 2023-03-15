resource "aws_s3_bucket" "main" {
  bucket  = var.name
  tags    = var.tags
}

resource "aws_s3_bucket_acl" "acl" {
  bucket  = aws_s3_bucket.main.id
  acl     = "private"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket  = aws_s3_bucket.main.id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}
