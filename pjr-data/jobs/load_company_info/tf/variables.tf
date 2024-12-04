variable "specific_region" {
  type    = string
  default = "europe-west3"
}

variable "remote_state_bucket" {
  type    = string
  default = "bkt-economedia-seed-tfstate-24e8"
}

variable "function_name" {
  type    = string
  default = "load_company_info"
}