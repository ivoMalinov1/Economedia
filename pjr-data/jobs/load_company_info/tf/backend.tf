terraform {
  backend "gcs" {
    bucket = "bkt-economedia-economedia-infra-cicd-tfstate"
    prefix = "jobs/load_company_info"
  }
}
