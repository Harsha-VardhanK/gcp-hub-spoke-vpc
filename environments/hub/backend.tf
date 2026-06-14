terraform {
  backend "gcs" {
    bucket = "gcpai-iac-tfstate"
    prefix = "hub/networking"
  }
}