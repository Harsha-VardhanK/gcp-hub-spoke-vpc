terraform {
  backend "gcs" {
    bucket = "gcpai-iac-tfstate"
    prefix = "prod/networking"
  }
}
