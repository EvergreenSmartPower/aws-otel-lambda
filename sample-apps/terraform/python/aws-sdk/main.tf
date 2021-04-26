data "aws_region" "current" {}

# TODO(anuraaga): Replace with public layers, these currently only work with authenticated requests for testing.
locals {
  sdk_layer_arns = {
    "us-east-1" = "arn:aws:lambda:us-east-1:611364707713:layer:aws-otel-lambda-python-e6c1e7530c1d4fcce4ac3af5b354355edcbc7769:1"
  }
}

module "app" {
  source = "../../../../opentelemetry-lambda/python/sample-apps/deploy"

  collector_layer_arn      = null
  python_wrapper_layer_arn = lookup(local.sdk_layer_arns, data.aws_region.current.name, "invalid")
}