provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment     = "Dev"
      Name         = "Diego-Assessment"
    }
  }
}
