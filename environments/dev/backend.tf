terraform {
  backend "gcs" {
    bucket = "gcpai-iac-tfstate"
    prefix = "dev/networking"
  }
}