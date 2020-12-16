resource "aws_s3_bucket" "tfstate" {
  bucket = "hkak03key-tfadvent2020-stg-terraform"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7

    noncurrent_version_expiration {
      days = 32
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name           = "hkak03key-tfadvent2020-stg-terraform-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
