terraform {
  backend "gcs" {
    bucket = "bkt-economedia-economedia-infra-cicd-tfstate"
    prefix = "jobs/mailerlite_campaigns"
  }
}
