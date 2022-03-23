terraform {
  required_version = ">=1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=2.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">3.0"
    }
    local = {
      source = "hashicorp/local"
    }
  }

}


provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIARMY3ZCOR7LLQE4WB"
  secret_key = "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"
}

