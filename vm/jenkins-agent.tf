data "yandex_compute_image" "jenkins-agent_image" {
  family = "${local.server_settings.jenkins-agent.image}"
}

resource "yandex_compute_instance" "group_vm_server_jenkins-agent" {
  count       = "${local.server_settings.jenkins-agent.count_vm}"
  name        = "${local.name_group_list[1]}-${count.index}"
  platform_id = var.vm_server_platform_id

  resources {
    cores         = local.server_settings.jenkins-agent.cpu
    memory        = local.server_settings.jenkins-agent.ram
    core_fraction = local.server_settings.jenkins-agent.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.jenkins-agent_image.id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${var.default_user_name}:${local.ssh_key}"
  }
  connection {
    type        = "ssh"
    user        = var.default_user_name
    private_key = local.private_key
    host        = self.network_interface[0].nat_ip_address
  }

  provisioner "remote-exec" {
    inline = ["sudo yum install -y python3"]
  }

}