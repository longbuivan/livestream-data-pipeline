# Output value definitions
output "function_name" {
  value = aws_lambda_function.parse_json.function_name
}

output "Source-S3-bucket" {
 value = "${aws_s3_bucket.bucket-1.id}"
}

output "CSV-S3-bucket" {
 value = "${aws_s3_bucket.bucket-2.id}"
}

output "Dynammo-DB" {
 value = "${aws_dynamodb_table.dynamodb-table.name}"
}

output "glue_database" {
  value = "${aws_glue_catalog_database.glue_database_test.arn}"
}

output "glue_table" {
   value =  "${aws_glue_catalog_table.glue_table_test.arn}"
}