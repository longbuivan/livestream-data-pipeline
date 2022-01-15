resource "aws_kinesis_firehose_delivery_stream" "extend_parquet" {
    name        = "json-to-parquet-stream"
    destination = "extended_s3"

    extended_s3_configuration {
        role_arn   = aws_iam_role.firehose_role.arn
        bucket_arn = aws_s3_bucket.bucket-3.arn

        # Must be at least 64
        buffer_size = 128

        prefix =  "output/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
        error_output_prefix = "error/result=!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"

        # ... other configuration ...
        data_format_conversion_configuration {
            input_format_configuration {
                deserializer {
                hive_json_ser_de {}
                }
            }

            output_format_configuration {
                serializer {
                parquet_ser_de {}
                }
            }

            schema_configuration {
                database_name = aws_glue_catalog_database.glue_database_test.name
                role_arn      = aws_iam_role.firehose_role.arn
                table_name    = aws_glue_catalog_table.glue_table_test.name
            }
        }
    }
}