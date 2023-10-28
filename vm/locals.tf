locals {
  ### Список имен групп серверов
  name_group_list = ["jenkins-master", "jenkins-agent"]
  ### Указание количеств серверов в каждой группе
  #count_vm = 1
  #SSH ключ
  ssh_key = file("~/.ssh/id_rsa.pub")
  private_key = file("~/.ssh/id_rsa")


  ### параметры (физическаие и типы ОС) групп серверов.
  server_settings = {
    jenkins-master = {
      cpu           = 2
      ram           = 4
      core_fraction = 5
      image         = "ubuntu-20.04"
      count_vm      = 1
    },

    jenkins-agent = {
      cpu           = 2
      ram           = 4
      core_fraction = 5
      image         = "ubuntu-20.04"
      count_vm      = 1
    }
  }
}


