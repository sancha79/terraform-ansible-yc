resource "yandex_compute_instance" "vm" {
  count = 3
  name  = "vm-${count.index}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd81hgrcv6lsnkremf32" # Ubuntu 22.04
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_vpc_network" "network" {
  name = "my-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "my-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Генерация inventory для Ansible
resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tpl", {
    proxy_ip       = yandex_compute_instance.vm[0].network_interface.0.nat_ip_address
    proxy_hostname = yandex_compute_instance.vm[0].name
    app_ips        = slice([for vm in yandex_compute_instance.vm[*] : vm.network_interface.0.nat_ip_address], 1, 3)
    app_hostnames  = slice([for vm in yandex_compute_instance.vm[*] : vm.name], 1, 3)
  })
  filename = pathexpand("~/ansible/inventory.ini")
}

# Генерация переменных для Ansible
resource "local_file" "ansible_vars" {
  content = yamlencode({
    proxy_ip : yandex_compute_instance.vm[0].network_interface.0.nat_ip_address,
    app_ips : [for vm in slice(yandex_compute_instance.vm[*], 1, 3) : vm.network_interface.0.nat_ip_address]
  })
  filename = pathexpand("~/ansible/group_vars/all.yml")
}

output "vm_ips" {
  value = {
    for vm in yandex_compute_instance.vm[*] :
    vm.name => vm.network_interface.0.nat_ip_address
  }
}
