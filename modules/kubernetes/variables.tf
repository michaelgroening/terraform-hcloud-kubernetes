# kubernetes/variables.tf

# GENERAL
variable "hcloud_token" {
  default = ""
}

variable "hcloud_ssh_private_key" {
  type = string
}

variable "kubeconfig_path" {
  type = string
}

# NETWORK
variable "network_id" {
  type = string
}

variable "private_ips" {
  type = list(any)
}

# MASTER NODES
variable "master_nodes" {
  type = list(any)
}

# WORKER NODES
variable "worker_nodes" {
  type = list(any)
}

# POWER NODES
variable "power_nodes" {
  type = list(any)
}

# KUBERNETES
variable "kubernetes_version" {
  type = string
  default     = "1.23.6"
}

variable "cluster_name" {
  type = string
}
