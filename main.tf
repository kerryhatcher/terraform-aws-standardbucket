provider "aws" {
  region = var.Region
}

resource "aws_s3_bucket" "standard_bucket" {
  bucket   = var.Name
}

resource "aws_s3_bucket_acl" "standard_bucket" {
  bucket = aws_s3_bucket.standard_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "standard_bucket" {
  bucket = aws_s3_bucket.standard_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "standard_bucket" {
  bucket = aws_s3_bucket.standard_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_public_access_block" "standard_bucket" {
  bucket = aws_s3_bucket.destination.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_s3_bucket_policy" "standard_bucket" {
  bucket = aws_s3_bucket.standard_bucket.id
  policy = data.aws_iam_policy_document.standard_bucket.json
}

data "aws_iam_policy_document" "standard_bucket" {
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.standard_bucket.arn}",
      "${aws_s3_bucket.standard_bucket.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}