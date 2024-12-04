locals {
  analytics-dev                 = data.terraform_remote_state.projects-dev.outputs.base_shared_vpc_project_analytics
  analytics-test                = data.terraform_remote_state.projects-test.outputs.base_shared_vpc_project_analytics
  analytics-prod                = data.terraform_remote_state.projects-prod.outputs.base_shared_vpc_project_analytics
  data-dev                      = data.terraform_remote_state.projects-dev.outputs.base_shared_vpc_project_data
  data-test                     = data.terraform_remote_state.projects-test.outputs.base_shared_vpc_project_data
  data-prod                     = data.terraform_remote_state.projects-prod.outputs.base_shared_vpc_project_data
  artifact_registry_docker_type = "DOCKER"
}

data "terraform_remote_state" "projects-dev" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/projects/platform/development"
  }
}

data "terraform_remote_state" "projects-test" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/projects/platform/test"
  }
}

data "terraform_remote_state" "projects-prod" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/projects/platform/production"
  }
}