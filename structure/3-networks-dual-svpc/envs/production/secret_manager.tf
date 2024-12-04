resource "google_secret_manager_secret" "cloudflared_token" {
  project   = module.base_env.base_host_project_id
  secret_id = "cloudflared-token-${module.base_env.base_host_project_id}"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "cloudflared_id" {
  project   = module.base_env.base_host_project_id
  secret_id = "cloudflared-id-${module.base_env.base_host_project_id}"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "cloudflared_secret" {
  project   = module.base_env.base_host_project_id
  secret_id = "cloudflared-secret-${module.base_env.base_host_project_id}"

  replication {
    automatic = true
  }
}
