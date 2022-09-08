output "rds_address" {
  description = "Address for the RDS instance."
  value       = aws_db_instance.default_rds.address
}

output "rds_port" {
  description = "Port for the RDS instance."
  value       = aws_db_instance.default_rds.port
}

output "rds_username" {
  description = "Username for the RDS instance."
  value       = aws_db_instance.default_rds.username
}

output "rds_password" {
  description = "Password for the RDS instance."
  sensitive   = true
  value       = aws_db_instance.default_rds.password
}

output "s3_bucket_id" {
  description = "ID of the S3 bucket."
  value       = aws_s3_bucket.module_repository_bucket.id
}

output "s3_iam_user_access_key" {
  description = "Access key for the S3 IAM user."
  value       = aws_iam_access_key.s3_iam_user_access_key.id
}

output "s3_iam_user_secret_key" {
  description = "Secret key for the S3 IAM user."
  sensitive   = true
  value       = aws_iam_access_key.s3_iam_user_access_key.secret
}
