####S3####
#S3 bucket for put files as JSON
resource "aws_s3_bucket" "bucket-1" {
  bucket = "bucket-1-json"
  acl    = "private"
  force_destroy = true
}

#S3 bucket for save file as CSV
resource "aws_s3_bucket" "bucket-2" {
  bucket = "bucket-2-csv"
  acl    = "private"
  force_destroy = true
}

#S3 bucket for save file as CSV
resource "aws_s3_bucket" "bucket-3" {
  bucket = "bucket-3-parquet"
  acl    = "private"
  force_destroy = true
}

variable "s3_bucket" {
    default = {
      test = "bucket-3-parquet"
      real = ""
    }
}