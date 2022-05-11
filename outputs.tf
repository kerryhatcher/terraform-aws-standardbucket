output "bucket_name" {
  value = aws_s3_bucket.standard_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.standard_bucket.arn
}


output "bucket_domain_name" {
  value = aws_s3_bucket.standard_bucket.bucket_domain_name 
}

