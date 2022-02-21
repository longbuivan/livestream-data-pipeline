# Livestream Data Pipeline

## Problems

In order to understand user behaviors with Click-Stream data, the project presents how to fetch data from API with ETL processes placed in the data pipeline. Deployment with CICD on GithubAction setup to make sure of a Validation and Quality Check. Terraform is used as IaC for managing resources. Dockerizing AWS Mock with localstack for hosting resources on a local machine.

## Feature Engineering

- [ ] [F10] Understand Problems and Technical Discussion
- [ ] [F11] Set up Local Machine Environment
- [ ] [F12] CICD Set up with resources
- [ ] [F20] Ingesting data from API and push into Kinesis Data Stream
- [ ] [F21] Parsing and Flatting data and Send to Delivery Stream
- [ ] [F22] Storing Data into Lake-house
- [ ] [F30] Transforming Data with Slowly Changing Dimension
- [ ] [F31] Enriching Data with Data Processing method as Lambda Architect
- [ ] [F40] Setup Cloud Warehouse and needed permission
- [ ] [F41] Creating resources pulling data as Dimensional Model to Warehouseless
- [ ] [F50] Developing data monitoring
- [ ] [F51] Developing data quality and data validation
- [ ] [F60] Set up BI tools for visualizing data
- [ ] [F61] Setup Connection to write back data to lake-house
- [ ] [F63] Exposing API for end-user
- [ ] [F70] Deploy to AWS/Azure Cloud
- [ ] [F71] Embed Machine Learning Model to Data pipeline

## Technical Requirements

- Use Kinesis firehose to store data as parquet file.
- Can use Localstack và terraform và python
- Unit Test:

- pylint, pytest, UnitTesting
- pytest --cov-report html --cov=src --cov-fail-under=100 tests/

## How to start on local machine

### 1. Resources

- Docker Engine
- Terraform

### 2. Steps for starting

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
  > terraform apply --auto-approve
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
