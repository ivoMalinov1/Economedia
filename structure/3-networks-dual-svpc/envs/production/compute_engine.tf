data "google_secret_manager_secret_version" "cloudflared_token" {
  project = module.base_env.base_host_project_id
  secret  = "cloudflared-token-${module.base_env.base_host_project_id}"
}

data "google_secret_manager_secret_version" "cloudflared_id" {
  project = module.base_env.base_host_project_id
  secret  = "cloudflared-id-${module.base_env.base_host_project_id}"
}

data "google_secret_manager_secret_version" "cloudflared_secret" {
  project = module.base_env.base_host_project_id
  secret  = "cloudflared-secret-${module.base_env.base_host_project_id}"
}

resource "google_compute_address" "cloudflared-external-ip" {
  project      = module.base_env.base_host_project_id
  region       = "europe-west3"
  name         = "cloudflared-external-ip"
  network_tier = "STANDARD"
  address_type = "EXTERNAL"
}

resource "google_compute_address" "cloudflared-internal-ip" {
  project      = module.base_env.base_host_project_id
  region       = "europe-west3"
  name         = "cloudflared-internal-ip"
  subnetwork   = module.base_env.base_subnets_self_links[1]
  address_type = "INTERNAL"
  address      = "10.0.192.32"
}

resource "google_compute_instance" "datastream-proxy-vm" {
  depends_on     = [google_compute_address.cloudflared-external-ip, google_compute_address.cloudflared-internal-ip]
  project        = module.base_env.base_host_project_id
  name           = "datastream-proxy-vm"
  machine_type   = "e2-micro"
  zone           = "europe-west3-c"
  desired_status = "RUNNING"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = module.base_env.base_network_self_link
    subnetwork = module.base_env.base_subnets_self_links[1]
    network_ip = google_compute_address.cloudflared-internal-ip.address

    access_config {
      nat_ip       = google_compute_address.cloudflared-external-ip.address
      network_tier = "STANDARD"
    }
  }

  metadata_startup_script = <<SCRIPT
    echo "Startup Script started."

    wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
    mv ./cloudflared-linux-amd64 /usr/local/bin/cloudflared
    chmod a+x /usr/local/bin/cloudflared

    sysctl -w net.ipv4.ip_forward=1
    sysctl -w net.ipv4.conf.ens4.route_localnet=1

    echo "Making cloudflared dir."
    mkdir -p /root/.cloudflared/

    cat > /root/.cloudflared/dbspg.economedia.bg-1982a9bde007eddec0f52439d23bb5e844cc1db632df2939a58bf6a277675e0d-token << EOF
    ${data.google_secret_manager_secret_version.cloudflared_token.secret_data}
EOF

    cat > /root/.cloudflared/economedia.cloudflareaccess.com-org-token << EOF
    not-available
EOF

    echo "Open connection through cloudflared."
    nohup /usr/local/bin/cloudflared access tcp --id=${data.google_secret_manager_secret_version.cloudflared_id.secret_data}.access --secret=${data.google_secret_manager_secret_version.cloudflared_secret.secret_data} --hostname dbspg.economedia.bg --url 10.0.192.32:5432 &

    echo "Startup script executed."
SCRIPT


}

