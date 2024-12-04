terraform {
  backend "gcs" {
    bucket = "bkt-economedia-economedia-infra-cicd-tfstate"
    prefix = "jobs/subscriptions_dashboard"
  }
}
