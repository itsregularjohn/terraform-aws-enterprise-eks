provider "aws" {
  region  = "us-east-1"
  profile = local.profile_name

  assume_role {
    role_arn     = "arn:aws:iam::${local.production_account_id}:role/TerraformExecutionRole"
    session_name = "terraform-production-deployment"
    external_id  = "terraform-deployment"
  }
}

provider "kubernetes" {
  host                   = local.cluster_endpoint
  cluster_ca_certificate = base64decode(local.cluster_ca_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      local.cluster_name,
      "--region",
      local.region_name,
      "--profile",
      local.profile_name
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = local.cluster_endpoint
    cluster_ca_certificate = base64decode(local.cluster_ca_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        local.cluster_name,
        "--region",
        local.region_name,
        "--profile",
        local.profile_name
      ]
    }
  }
}
