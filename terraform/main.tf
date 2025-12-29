module "lambda_iam_dynamo" {
  source = "./modules/lambda_iam_dynamo"
  env    = var.env
}
# API Gateway REST API
resource "aws_api_gateway_rest_api" "health_api" {
  name        = "${var.env}-health-api"
  description = "API Gateway for health check Lambda"
  
}
# /health resource
resource "aws_api_gateway_resource" "health" {
  rest_api_id = aws_api_gateway_rest_api.health_api.id
  parent_id   = aws_api_gateway_rest_api.health_api.root_resource_id
  path_part   = "health"
}
# GET method
resource "aws_api_gateway_method" "health_get" {
  rest_api_id   = aws_api_gateway_rest_api.health_api.id
  resource_id   = aws_api_gateway_resource.health.id
  http_method   = "GET"
  authorization = "NONE"
}
# Lambda integration
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.health_api.id
  resource_id             = aws_api_gateway_resource.health.id
  http_method             = aws_api_gateway_method.health_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_iam_dynamo.lambda_invoke_arn
}
# Permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_iam_dynamo.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.health_api.execution_arn}/*/*"
}

# Deploy API
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.health_api.id
   # Force new deployment on API changes
  triggers = {
    redeploy = sha1(jsonencode(aws_api_gateway_rest_api.health_api))
  }
}

resource "aws_api_gateway_stage" "stage" {
  stage_name    = var.env          # "staging" or "prod"
  rest_api_id   = aws_api_gateway_rest_api.health_api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
}

# Output API URL
output "api_url" {
  value = "${aws_api_gateway_stage.stage.invoke_url}/health"
}

