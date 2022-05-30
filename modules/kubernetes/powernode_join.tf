# kubernetes/kubeadm_join.tf

resource "null_resource" "powernode_join" {
  count      = length(var.power_nodes)
  depends_on = [null_resource.install]

  connection {
    host  = element(var.power_nodes.*.ipv4_address, count.index)
    user  = "root"
    type  = "ssh"
    private_key = file("${var.hcloud_ssh_private_key}")
    agent = false
  }

  provisioner "local-exec" {
    command = <<EOT
      ssh -i ${var.hcloud_ssh_private_key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        root@${local.master_ip} 'echo $(kubeadm token create) > /tmp/kubeadm_token'
    EOT
  }

  provisioner "local-exec" {
    command = <<EOT
      scp -i ${var.hcloud_ssh_private_key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        root@${local.master_ip}:/tmp/kubeadm_token \
        /tmp/kubeadm_token
    EOT
  }

  provisioner "file" {
    source      = "/tmp/kubeadm_token"
    destination = "/tmp/kubeadm_token"
  }

  provisioner "remote-exec" {
    inline = [
      data.template_file.power.rendered
    ]
  }
}

data "template_file" "power" {
  template = file("${path.module}/scripts/power.sh")

  vars = {
    master_private_ip = local.master_private_ip
  }
}

resource "null_resource" "powernode_label" {
  depends_on = [
    null_resource.powernode_join
  ]
  count = length(local.powernode_connections)

  connection {
    host  = element(var.master_nodes.*.ipv4_address,0)
    user  = "root"
    type  = "ssh"
    private_key = file("${var.hcloud_ssh_private_key}")
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "kubectl label --overwrite nodes power-${count.index+1} nodeclass=power"
    ]
  }

}
