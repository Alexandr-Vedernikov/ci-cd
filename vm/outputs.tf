### Создание inventory файл для работы Ansible.
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      jenkins-master = yandex_compute_instance.group_vm_server_jenkins-master
      jenkins-agent  = yandex_compute_instance.group_vm_server_jenkins-agent
      username = var.default_user_name
    }
  )
  filename = "../${path.module}/inventory/cicd/hosts.yml"
}