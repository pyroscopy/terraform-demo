output "bucket_id" {
  description = "생성된 S3 버킷의 ID"
  value       = aws_s3_bucket.my_bucket.id
}

output "bucket_arn" {
  description = "생성된 S3 버킷의 ARN"
  value       = aws_s3_bucket.my_bucket.arn
}