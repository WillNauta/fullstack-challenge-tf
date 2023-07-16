provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# AWS Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "example" {
  name        = "example"
  description = "Example Elastic Beanstalk Application"
}

# AWS Elastic Beanstalk Environment (devel)
resource "aws_elastic_beanstalk_environment" "devel" {
  name                = "devel"
  application         = aws_elastic_beanstalk_application.example.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.6 running Node.js 14"
  version_label       = "devel"

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "NODE_ENV"
    value     = "devel"
  }
}

# AWS Elastic Beanstalk Environment (stage)
resource "aws_elastic_beanstalk_environment" "stage" {
  name                = "stage"
  application         = aws_elastic_beanstalk_application.example.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.6 running Node.js 14"
  version_label       = "stage"

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "NODE_ENV"
    value     = "stage"
  }
}

# AWS Elastic Beanstalk Environment (prod)
resource "aws_elastic_beanstalk_environment" "prod" {
  name                = "prod"
  application         = aws_elastic_beanstalk_application.example.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.6 running Node.js 14"
  version_label       = "prod"

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "NODE_ENV"
    value     = "prod"
  }
}

# AWS ACM SSL Certificate
resource "aws_acm_certificate" "example" {
  domain_name       = "*.example.com"  # Replace with your domain name
  validation_method = "EMAIL"

  lifecycle {
    create_before_destroy = true
  }
}

# AWS ACM SSL Certificate Validation
resource "aws_acm_certificate_validation" "example" {
  certificate_arn = aws_acm_certificate.example.arn

  lifecycle {
    create_before_destroy = true
  }
}

# AWS Elastic Beanstalk Application Version (devel)
resource "aws_elastic_beanstalk_application_version" "devel" {
  name        = "devel"
  application = aws_elastic_beanstalk_application.example.name
  description = "Example Application Devel Version"

  source_bundle {
    s3_bucket = aws_s3_bucket.example.id
    s3_key    = "example-devel.zip"
  }
}

# AWS Elastic Beanstalk Application Version (stage)
resource "aws_elastic_beanstalk_application_version" "stage" {
  name        = "stage"
  application = aws_elastic_beanstalk_application.example.name
  description = "Example Application Stage Version"

  source_bundle {
    s3_bucket = aws_s3_bucket.example.id
    s3_key    = "example-stage.zip"
  }
}

# AWS Elastic Beanstalk Application Version (prod)
resource "aws_elastic_beanstalk_application_version" "prod" {
  name        = "prod"
  application = aws_elastic_beanstalk_application.example.name
  description = "Example Application Prod Version"

  source_bundle {
    s3_bucket = aws_s3_bucket.example.id
    s3_key    = "example-prod.zip"
  }
}

# AWS S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "example-terraform"  # Replace with your desired bucket name
  acl    = "private"

  lifecycle {
    prevent_destroy = false
  }
}

# AWS S3 Bucket Object (devel)
resource "aws_s3_bucket_object" "devel" {
  bucket = aws_s3_bucket.example.id
  key    = "example-devel.zip"
  source = "example-deployable-files/devel.zip"  # Replace with your deployment file

  etag = filemd5("example-deployable-files/devel.zip")  # Replace with your deployment file
}

# AWS S3 Bucket Object (stage)
resource "aws_s3_bucket_object" "stage" {
  bucket = aws_s3_bucket.example.id
  key    = "example-stage.zip"
  source = "example-deployable-files/stage.zip"  # Replace with your deployment file

  etag = filemd5("example-deployable-files/stage.zip")  # Replace with your deployment file
}

# AWS S3 Bucket Object (prod)
resource "aws_s3_bucket_object" "prod" {
  bucket = aws_s3_bucket.example.id
  key    = "example-prod.zip"
  source = "example-deployable-files/prod.zip"  # Replace with your deployment file

  etag = filemd5("example-deployable-files/prod.zip")  # Replace with your deployment file
}

# AWS Elastic Beanstalk Application Version Lifecycle Policy
resource "aws_elastic_beanstalk_application_version_lifecycle_policy" "example" {
  application  = aws_elastic_beanstalk_application.example.name
  max_age_rule {
    enabled  = true
    max_age  = 90
    delete_source_from_s3 = true
  }
}

# AWS Elastic Beanstalk Environment Update Trigger
resource "aws_elastic_beanstalk_environment" "example_update_trigger" {
  name         = "example_update_trigger"
  application  = aws_elastic_beanstalk_application.example.name
  environment  = aws_elastic_beanstalk_environment.devel.id
  trigger_name = "example_trigger"

  provisioner {
    action = "pause"
    type   = "pre_traffic"
  }
}