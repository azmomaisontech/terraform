module "s3_bucket" {
  source       = "../../modules/aws/s3"
  environment  = "prod"
  product_name = "test-one"

  providers = {
    aws = aws.us-west-2
  }
}
