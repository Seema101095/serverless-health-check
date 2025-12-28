module "lambda_iam_dynamo" {
  source = "./modules/lambda_iam_dynamo"
  env    = var.env
}