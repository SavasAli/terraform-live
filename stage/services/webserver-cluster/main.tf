terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

    backend "s3" {
    bucket  = "terraform-up-and-running-state-savas"
    key     = "stage/services/webserver-cluster/terraform.tfstate"
    region  = "us-east-2"    

    dynamodb_table  = "terraform-up-and-running-locks"
    encrypt         = true
  }
}

provider "aws" {
  region = "us-east-2"
}

module "webserver-cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name            = var.cluster_name
  db_remote_state_bucket  = var.db_remote_state_bucket
  db_remote_state_key     = var.db_remote_state_key

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}