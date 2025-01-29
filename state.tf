terraform {
  backend "s3" {
    bucket = "terraform-state-kubestack-5415b8c"
    region = "eu-west-3"
    key    = "tfstate"
  }
}
