resource "google_compute_firewall" "dataflow_firewall" {
  name        = "dataflow-ingress"
  network     = module.main.network_name
  project     = var.project_id
  direction   = "INGRESS"
  priority    = 1000
  target_tags = ["dataflow"]

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [
      {
        metadata = "INCLUDE_ALL_METADATA"
      }
    ] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  allow {
    protocol = "tcp"
    ports    = ["12345-12346"]
  }

  source_ranges = [
    "10.0.64.0/21",
    "10.1.64.0/21",
  ]

}

resource "google_compute_firewall" "dataflow_firewall_egress" {
  name        = "dataflow-tcp-egress"
  network     = module.main.network_name
  project     = var.project_id
  direction   = "EGRESS"
  priority    = 1000
  target_tags = ["dataflow"]

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [
      {
        metadata = "INCLUDE_ALL_METADATA"
      }
    ] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  allow {
    protocol = "tcp"
    ports    = ["12345-12346"]
  }

  destination_ranges = [
    "10.0.64.0/21",
    "10.1.64.0/21",
  ]

}

resource "google_compute_firewall" "allow-datastream-to-postgresql" {
  name        = "allow-datastream-to-postgresql"
  network     = module.main.network_name
  project     = var.project_id
  direction   = "INGRESS"
  priority    = 1000
  source_ranges = [
    "10.80.0.0/24"
  ]

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
}