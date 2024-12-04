terraform {
  backend "gcs" {
    bucket = "bkt-economedia-economedia-infra-cicd-tfstate"
    prefix = "jobs/content_dashboard"
  }
}
