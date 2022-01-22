# Livestream Data Pipeline

## Problems

1. Create s3, dynamodb, iam and 1 lambda to read file json from s3 bucket 1, parse and save in s3 bucket 2 with csv, each time parsedwill count +1 in dynamodb.
2. Partition by ingestion time.
3. Parse and save as parquet file in s3 bucket 3.
4. Save file with datetime partition.

## Technical Requirements

- Use kenesis firehose to store data as parquet file.
- Can use localstack và terraform và python
- Unit Test:

- pylint, pytest, UnitTesting
- pytest --cov-report html --cov=src --cov-fail-under=100 tests/

## How to start on local machine

1. Resources:

- Docker Engine
- Terraform

2. Steps for starting

- Build localstack if none:
  > docker-compose -f docker-compose.yml up -d --build
- Change directory to `./terraform` for starting terraform
  > cd .terraform
- Init Terraform backend
  > terraform init -input=false
- Terraform syntax validation
  > terraform validate
- Plan for seeing any changes on resources
  > terraform plan
- Deploy for new resources creation
  > terraoform apply --auto-approve
- Destroy resources with
  > terraform destroy

## CICD Set-up
`ci-pipeline` has been set up for running ci on Github Action
Please do not modify if need
Jobs on CI pipeline:
- python-job:
  - Checkout
  - Clean environment
  - Install and Lint with Flake8
  - Install poetry
  - Install dependencies
  - Pylint check
  - Pytest check
  - Run out coverage
- terraform-job:
  - Checkout
  - Start Container localstack with Docker image
  - Plan resources
  - Apply resources
  - Destroy resources
  - Stop Container


**Notes** [Reference](https://docs.docker.com/ci-cd/github-actions/)
