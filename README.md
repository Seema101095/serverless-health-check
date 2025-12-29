# Serverless Health Check API

## Project Description

This project implements a **serverless health check API** using AWS Lambda, API Gateway, and DynamoDB.  
It demonstrates **multi-environment deployments** with Terraform and a CI/CD pipeline using GitHub Actions.

The `/health` endpoint logs requests, stores them in DynamoDB, and responds with a JSON message.

---

## Project Structure

.
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── provider.tf
│   ├── modules/
│   │   └── lambda_iam_dynamo/
│   │       ├── lambda.zip
│   │       ├── main.tf
│   │       ├── output.tf
│   │       └── variables.tf
│   ├── staging.tfvars
│   ├── prod.tfvars
│   └── .gitignore
│
├── lambda/
│   └── handler.py
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
└── README.md


## Prerequisites

- Terraform >= 1.5.0  
- AWS CLI configured with access key and secret key  
- Python 3.11 (for Lambda function)  
- GitHub account (for CI/CD workflow)

---

## Deployment Instructions

### Initialize Terraform

```bash
cd terraform
terraform init

Deploy Staging Environment
terraform apply -var-file="staging.tfvars"

Deploy Production Environment
terraform apply -var-file="prod.tfvars"


Resources are automatically named based on env variable:

staging-health-check-function / prod-health-check-function

staging-requests-db / prod-requests-db

#Testing the API
api_url = https://<api-id>.execute-api.<region>.amazonaws.com/staging/health

#Test the endpoint
https://jq1wge8ol2.execute-api.us-east-1.amazonaws.com/staging/health

#Expected Response
{"status": "healthy", "message": "Request processed and saved."}
DynamoDB will store each request with a unique request_id.
CloudWatch logs Lambda invocations for monitoring.

#CI/CD Pipeline (GitHub Actions)

Workflow file: .github/workflows/deploy.yml
Automatically runs on push to main branch.
Steps:
Set AWS credentials via GitHub Secrets (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
Run terraform init
Run terraform plan -var-file="$ENV.tfvars"
Run terraform apply -var-file="$ENV.tfvars" -auto-approve
Supports staging and production deployments.

#Design Choices / Assumptions

Environment separation: staging and prod using .tfvars files
Resource naming convention: env-resource-name
API Gateway integration: AWS_PROXY for Lambda
IAM Role: Least privilege, allows DynamoDB write and CloudWatch logging
Module structure: Terraform module lambda_iam_dynamo for Lambda, IAM, and DynamoDB
Lambda code: Python 3.11, stores requests in DynamoDB and logs to CloudWatch

