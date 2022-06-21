# firewall/main.tf

variable "connections" {
  type = list(any)
}

variable "subnet_ip_range" {
  type = string
}

variable "hcloud_ssh_private_key" {
  type = string
}

resource "null_resource" "firewall" {
  count = length(var.connections)

  triggers = {
    template = templatefile("${path.module}/scripts/ufw.sh",{ subnet_ip_range = var.subnet_ip_range})
  }


  connection {
    host  = element(var.connections, count.index)
    user  = "root"
    type  = "ssh"
    private_key = file("${var.hcloud_ssh_private_key}")
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      templatefile("${path.module}/scripts/ufw.sh",{ subnet_ip_range = var.subnet_ip_range})
    ]
  }
}
