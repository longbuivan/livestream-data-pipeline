## Problems:

1. Create s3, dynamodb, iam and 1 lambda to read file json from s3 bucket 1, parse and save in s3 bucket 2 with csv, each time parsedwill count +1 in dynamodb.
2. Partition by ingestion time.
3. Parse and save as parquet file in s3 bucket 3.
4. Save file with datetime partition.

## Technical Requirements:

- Use kenesis firehose to store data as parquet file.
- Can use localstack và terraform và python
- Unit Test:

* pylint, pytest, UnitTesting
* pytest --cov-report html --cov=src --cov-fail-under=100 tests/

## CICD Set up

Before we start, ensure you can access Docker Hub from any workflows you create. To do this:

1. Add your Docker ID as a secret to GitHub. Navigate to your GitHub repository and click Settings > Secrets > New secret.

2. Create a new secret with the name DOCKER_HUB_USERNAME and your Docker ID as value.

3. Create a new Personal Access Token (PAT). To create a new token, go to Docker Hub Settings and then click New Access Token.

4. Let’s call this token simplewhaleci.
![Create github access](https://docs.docker.com/ci-cd/images/github-access-token.png)


5. Now, add this Personal Access Token (PAT) as a second secret into the GitHub secrets UI with the name DOCKER_HUB_ACCESS_TOKEN.
![New access token](https://docs.docker.com/ci-cd/images/github-secrets.png)

**Notes** [Reference](https://docs.docker.com/ci-cd/github-actions/)
