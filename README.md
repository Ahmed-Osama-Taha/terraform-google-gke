# 🌐 GKE Terraform Module

A reusable, production-ready Terraform module to deploy **Google Kubernetes Engine (GKE)** clusters using **VPC-native networking**, **Workload Identity**, and **custom node pools**.

---

## 📌 Features

- Private GKE cluster with no public IPs for nodes
- IP aliasing with VPC-native networking
- Workload Identity support (no need for service account keys)
- Custom node pools with autoscaling, node metadata, and secure boot
- Shielded nodes and secure metadata access
- Supports multiple environments with default and overridable inputs

---

## 🧱 Module Structure

```
terraform-google-modules/
└── terraform-google-gke/
    ├── main.tf             # GKE cluster definition
    ├── node_pools.tf       # Node pools resource
    ├── variables.tf        # Input variable definitions
    ├── outputs.tf          # Output values (cluster name, endpoint, etc.)
    └── README.md           # Module documentation (this file)
```

---

## ⚙️ Usage

### 1. Call the Module in Your Root Configuration

```hcl
module "gke" {
  source  = "./terraform-google-modules/terraform-google-gke"

  project_id             = var.project_id
  region                 = var.region
  name                   = "prod-gke-cluster"
  network                = google_compute_network.vpc.self_link
  subnetwork             = google_compute_subnetwork.subnet.self_link
  enable_private_nodes   = true
  enable_workload_identity = true

  node_pools = [
    {
      name         = "default-pool"
      machine_type = "e2-medium"
      min_count    = 1
      max_count    = 3
    },
    {
      name         = "high-memory-pool"
      machine_type = "n2-highmem-4"
      min_count    = 0
      max_count    = 2
    }
  ]
}
```

---

## 🔁 Input Variables

| Name                      | Type           | Default  | Description                                                                 |
|---------------------------|----------------|----------|-----------------------------------------------------------------------------|
| `project_id`              | `string`       | _n/a_    | The Google Cloud project ID.                                                |
| `region`                  | `string`       | _n/a_    | Region for the GKE cluster.                                                 |
| `name`                    | `string`       | _n/a_    | Name of the GKE cluster.                                                    |
| `network`                 | `string`       | _n/a_    | VPC self-link where GKE will be deployed.                                   |
| `subnetwork`              | `string`       | _n/a_    | Subnetwork self-link for GKE.                                               |
| `enable_private_nodes`    | `bool`         | `true`   | Enable private nodes (no external IPs).                                     |
| `enable_workload_identity`| `bool`         | `true`   | Enable Workload Identity integration.                                       |
| `node_pools`              | `list(any)`    | `[]`     | List of node pool objects with `name`, `machine_type`, `min_count`, `max_count`. |

---

## 📤 Outputs

| Name             | Description                        |
|------------------|------------------------------------|
| `cluster_name`   | Name of the GKE cluster            |
| `cluster_endpoint` | Endpoint of the GKE master API     |

---

## 🧩 Node Pools Explained

A **node pool** is a group of Kubernetes worker nodes (VMs) with the same configuration. You can define multiple pools for different workloads (e.g., frontend, backend, ML):

Example:
```hcl
node_pools = [
  {
    name         = "frontend"
    machine_type = "e2-standard-2"
    min_count    = 1
    max_count    = 3
  },
  {
    name         = "backend"
    machine_type = "e2-highmem-4"
    min_count    = 2
    max_count    = 5
  }
]
```

---

## 🔒 Security Features

- ✅ Shielded VMs (secure boot)
- ✅ Workload Identity (no service account keys)
- ✅ Private cluster (no public control plane or node IPs)
- ✅ Metadata access lockdown
- ✅ Master Authorized Networks (IP whitelisting)

---

## 🧠 Best Practices

- Always define **node_pools** explicitly. Don’t use default node pool.
- Use **Workload Identity** to avoid managing key files.
- Tag and label node pools for specific workloads.
- Lock down `master_authorized_networks_config` to only your trusted IP ranges.
- Use `release_channel` to ensure stable updates.

---

## 🖼️ Architecture

```plaintext
 ┌──────────────────────────────────────────────┐
 │              Google Cloud Project            │
 │                                              │
 │  ┌────────────┐        ┌─────────────────┐   │
 │  │  VPC       │        │   Subnetwork    │   │
 │  └────┬───────┘        └────────┬────────┘   │
 │       │                         │            │
 │       ▼                         ▼            │
 │  ┌──────────────┐      ┌─────────────────┐   │
 │  │   GKE Master │◄─────┤ Node Pool(s)     │   │
 │  │  (private)   │      │  (e.g. e2-medium)│   │
 │  └──────────────┘      └─────────────────┘   │
 │         ▲                                         
 │         └── Authorized Networks (Office IP)       │
 └──────────────────────────────────────────────┘
```

---

## 🔗 References

- [GKE Terraform Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster)
- [Workload Identity Docs](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)
- [IP Aliasing](https://cloud.google.com/kubernetes-engine/docs/how-to/ip-aliases)
- [Terraform GKE Module Examples](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine)

---

## 👤 Maintainer

> 🛠️ **Ahmed Osama Taha**  
> DevOps Engineer | Terraform | Kubernetes | GCP  
> 📧 ahmed.osama.taha2@gmail.com 
> 💼 [LinkedIn](https://www.linkedin.com/in/ahmed-osama-taha)

For questions, improvements, or merge requests, please contact the maintainer or the DevOps platform team.

---

## 🏁 License

MIT License – use freely in internal and external projects.
