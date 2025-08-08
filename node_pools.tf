resource "google_container_node_pool" "pools" {
  for_each = { for p in var.node_pools : p.name => p }

  name       = each.key
  project    = var.project_id
  location   = var.region
  cluster    = google_container_cluster.primary.name

  node_config {
    machine_type = each.value.machine_type
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
    workload_metadata_config {
      mode = "GKE_METADATA" # recommended, but with Workload Identity prefer workload identity
    }
    shielded_instance_config {
      enable_secure_boot = true
    }
  }

  autoscaling {
    min_node_count = each.value.min_count
    max_node_count = each.value.max_count
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }
}
