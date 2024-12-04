module "folder-iam-dev" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  count   = var.env == "development" ? 1 : 0
  folders = [google_folder.env.id]

  bindings = {
    "roles/editor" = [
      "serviceAccount:${local.project_step_sa}"
    ]
  }
}

module "folder-iam-prod" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  count   = var.env == "production" ? 1 : 0
  folders = [google_folder.env.id]

  bindings = {
    "roles/editor" = [
      "serviceAccount:${local.project_step_sa}"
    ]
  }
}

module "folder-iam-test" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  count   = var.env == "test" ? 1 : 0
  folders = [google_folder.env.id]

  bindings = {
    "roles/editor" = [
      "serviceAccount:${local.project_step_sa}"
    ]
  }
}