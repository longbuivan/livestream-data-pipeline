resource "aws_glue_catalog_database" "glue_database_test" {
    name = "database_test"
}

resource "aws_glue_catalog_table" "glue_table_test" {
    name = "table-test"
    database_name = aws_glue_catalog_database.glue_database_test.name
    table_type = "EXTERNAL_TABLE"
    parameters = {
        EXTERNAL              = "TRUE"
        "parquet.compression" = "SNAPPY"
        "projection.enabled" = "true",
        "projection.year.type" = "date",
        "projection.year.range" = "2021,NOW",
        "projection.year.format" = "yyyy",
        "projection.year.internal.unit" = "YEARS",
        "projection.month.type" = "integer",
        "projection.month.range" = "1,12",
        "projection.month.digits" = "2",
        "projection.day.type" = "integer",
        "projection.day.range" = "1,31",
        "projection.day.digits" = "2",
        "projection.hour.type" = "integer",
        "projection.hour.range" = "0,23",
        "projection.hour.digits" = "2",
        "storage.location.template" = "s3://bucket-3-parquet/output/year=$${year}/month=$${month}/day=$${day}/hour=$${hour}"
    }
    storage_descriptor {
        location      = "s3://bucket-3-parquet/"
        input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
        output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
        ser_de_info {
            name                  = "my-test-stream"
            serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
            parameters = {
                "serialization.format" = 1
            }
        }
        columns {
            name = "index"
            type = "int"
        }
        columns {
            name = "LocationID"
            type = "int"
        }
        columns {
            name = "Name"
            type = "string"
        }
        columns {
            name = "CostRate"
            type = "float"
        }
        columns {
            name = "Availability"
            type = "float"
        }
        columns {
            name = "ModifiedDate"
            type = "timestamp"
        }
    }
    partition_keys {
        name = "year"
        type = "int"
    }
    partition_keys {
        name = "month"
        type = "int"
    }
    partition_keys {
        name = "day"
        type = "int"
    }
    partition_keys {
        name ="hour"
        type = "int"
    }
}
