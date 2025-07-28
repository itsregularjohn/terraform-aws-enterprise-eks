data "terraform_remote_state" "organizations" {
  backend = "s3"
  config = {
    bucket     = "jp-terraform-showcase-terraform"
    key        = "management/global/organizations/terraform.tfstate"
    region     = "us-east-1"
    profile    = "terraform-showcase"
  }
}

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket  = "jp-terraform-showcase-terraform"
    key     = "production/us-east-1/networking/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-showcase"
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket  = "jp-terraform-showcase-terraform"
    key     = "production/us-east-1/eks-cluster/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-showcase"
  }
}