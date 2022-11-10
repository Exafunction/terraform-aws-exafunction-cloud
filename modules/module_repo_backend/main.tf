###############################################################################
# RDS                                                                         #
###############################################################################
resource "random_password" "rds_password" {
  length           = 64
  special          = true
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "default_rds" {
  identifier             = "${var.exadeploy_id}-rds"
  allocated_storage      = var.db_storage
  engine                 = "postgres"
  engine_version         = var.postgres_version
  instance_class         = var.db_instance_class
  db_name                = "postgres"
  username               = var.db_username
  password               = random_password.rds_password.result
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  port                   = var.db_port
  storage_encrypted      = var.db_storage_encrypted
  skip_final_snapshot    = true
}

###############################################################################
# S3                                                                          #
###############################################################################

# Randomized suffix is needed because S3 bucket names must be globally unique.
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "module_repository_bucket" {
  bucket = "module-repo-${var.exadeploy_id}-${random_string.bucket_suffix.result}"
  # Force destroy enabled so Terraform can destroy the bucket even if it's not empty.
  force_destroy = true
}

resource "aws_s3_bucket_acl" "module_repository" {
  bucket = aws_s3_bucket.module_repository_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "module_repository" {
  bucket = aws_s3_bucket.module_repository_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_user" "s3_iam_user" {
  name = "${var.exadeploy_id}-user"
  path = "/exafunction/"
}

resource "aws_iam_access_key" "s3_iam_user_access_key" {
  user = aws_iam_user.s3_iam_user.name
}

data "aws_iam_policy_document" "bucket_policy_document" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.s3_iam_user.arn]
    }

    actions = [
      "s3:*Object",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.module_repository_bucket.arn,
      "${aws_s3_bucket.module_repository_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "module_repository_bucket_policy" {
  bucket = aws_s3_bucket.module_repository_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy_document.json
}
