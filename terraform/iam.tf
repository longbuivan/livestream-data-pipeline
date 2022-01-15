####IAM###
#LambdaExcecution IAM Policies
resource "aws_iam_policy" "LambdaExecutionPolicy" {
  name = "lambda_policy"

policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:CopyObject",
        "s3:HeadObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.bucket-1.id}",
        "arn:aws:s3:::${aws_s3_bucket.bucket-1.id}/*"
      ]
    },
    {
      "Action": [
        "s3:ListBucket",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:CopyObject",
        "s3:HeadObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.bucket-2.id}",
        "arn:aws:s3:::${aws_s3_bucket.bucket-2.id}/*"
      ]
    },
    {
      "Action": [
        "s3:ListBucket",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:CopyObject",
        "s3:HeadObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.bucket-3.id}",
        "arn:aws:s3:::${aws_s3_bucket.bucket-3.id}/*"
      ]
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:GetRecords",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:Query"
      ],
      "Effect": "Allow",
      "Resource": "${aws_dynamodb_table.dynamodb-table.arn}"
    },
    {
      "Action": [
        "firehose:PutRecord",
        "firehose:PutRecordBatch"
      ],
      "Effect": "Allow",
      "Resource": "${aws_kinesis_firehose_delivery_stream.extend_parquet.arn}"
    }
  ]
}
EOF

}


resource "aws_iam_policy" "FirehoseExecutionPolicy" {
  name = "firehose_policy"

policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:CopyObject",
        "s3:HeadObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.bucket-3.id}",
        "arn:aws:s3:::${aws_s3_bucket.bucket-3.id}/*"
      ]
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "glue:GetDatabase",
        "glue:GetDatabases",
        "glue:GetPartition",
        "glue:GetPartitions",
        "glue:GetTable",
        "glue:GetTableVersion",
        "glue:GetTableVersions",
        "glue:GetTables"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}

#LambdaExecution IAM Resources
resource "aws_iam_role" "LambdaExecution" {
  name = "LambdaExecution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#Attach Role and Polices
resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_basic_execution" {
 role = "${aws_iam_role.LambdaExecution.id}"
 policy_arn = "${aws_iam_policy.LambdaExecutionPolicy.arn}"
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


#Attach Role and Polices
resource "aws_iam_role_policy_attachment" "terraform_firehose_iam_policy_basic_execution" {
 role = "${aws_iam_role.firehose_role.id}"
 policy_arn = "${aws_iam_policy.FirehoseExecutionPolicy.arn}"
}




