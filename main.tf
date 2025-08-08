resource "google_container_cluster" "primary" {
  name     = var.name
  project  = var.project_id
  location = var.region

  # Networking
  network    = var.network
  subnetwork = var.subnetwork

  # Private cluster
  private_cluster_config {
    enable_private_nodes = var.enable_private_nodes
    enable_private_endpoint = false
    master_ipv4_cidr_block = "172.16.0.0/28"
  }

  # Control plane authorized networks (lock down admin access)
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"  # in prod this should be restricted to a certain ip range
      display_name = "testing_only"
    }
  }

  # Enable Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
  }

  # networking_mode = "VPC_NATIVE" # using alias IPs deprecated

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  remove_default_node_pool = true
  initial_node_count = 1

  release_channel {
    channel = "regular"
  }
}
