resource "aws_s3_bucket" "test_bucket" {
  bucket = "llm-gateway-test-bucket"
}

resource "aws_s3_bucket_public_access_block" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
