
resource "aws_s3_bucket" "terraform-workspace-state" {
  bucket        = "tfstate"
  acl           = "private"
  force_destroy = true 
}

resource "aws_s3_bucket" "web_raw_data_s3" {
  bucket = "${var.environment}-web-raw-data-s3"
  acl    = "private"
  versioning {
    enabled = false
  }
  tags = local.tags
}

resource "aws_s3_bucket" "web_flatten_data_s3" {
  bucket = "${var.environment}-web-flatten-data-s3"
  acl    = "private"
  versioning {
    enabled = false
  }
  tags = local.tags
}
