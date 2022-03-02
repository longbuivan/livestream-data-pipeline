resource "aws_iam_policy" "lambda_execution_policy" {
  name = "lambda-execution-policy"

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
        "arn:aws:s3:::${var.environment}-web-raw-data-s3.id}",
        "arn:aws:s3:::${var.environment}-web-raw-data-s3.id}/*"
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
        "firehose:PutRecord",
        "firehose:PutRecordBatch"
      ],
      "Effect": "Allow",
      "Resource": "${aws_kinesis_firehose_delivery_stream.data_delivery_stream_s3.arn}"
    }
  ]
}
EOF

}


resource "aws_iam_policy" "firehose-execution-policy" {
  name = "firehose-execution-policy"

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
        "arn:aws:s3:::${var.environment}-web-flatten-data-s3",
        "arn:aws:s3:::${var.environment}-web-flatten-data-s3/*"
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

#lambda_execution_role IAM Resources
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"

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
resource "aws_iam_role_policy_attachment" "lambda_iam_policy_basic_execution" {
  role       = aws_iam_role.lambda_execution_role.id
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose-role"

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
  role       = aws_iam_role.firehose_role.id
  policy_arn = aws_iam_policy.firehose-execution-policy.arn
}




