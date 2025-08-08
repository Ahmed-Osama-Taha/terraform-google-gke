variable "project_id" { 
    type = string 
}
variable "region"     { 
    type = string 
}
variable "name"       { 
    type = string 
}
variable "network"    { 
    type = string 
}    # vpc self_link
variable "subnetwork" { 
    type = string 
}    # subnet self_link
variable "enable_private_nodes" { 
    type = bool
    default = true
}
variable "enable_workload_identity" { 
    type = bool
    default = true
}
variable "node_pools" { 
    type = list(any) 
    default = [] 
}  # list of maps for pools
