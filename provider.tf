terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.5.0"
    }
  }


backend "s3" {
    bucket = "exp-ni-backend"
    key = "terraform/state-file"
    region = "us-west-2"
 } 
}

