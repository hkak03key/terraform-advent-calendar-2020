terraform {
  backend "s3" {
    bucket         = "hkak03key-tfadvent2020-prod-terraform"
    key            = "terraform.state"
    region         = "ap-northeast-1"
    profile        = "hkak03key-tfadvent2020-prod"
    dynamodb_table = "hkak03key-tfadvent2020-prod-terraform-lock"
  }
}

