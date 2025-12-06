locals {
  common_resources = {
    cores         = 2
    core_fraction = 20
    memory        = 2 # GB
    disk_size     = 10
  }

  ubuntu_image_id = "" #
}

# bastion – публичный
resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  zone        = "ru-central1-b"
  platform_id = "standard-v3"

  resources {
    cores         = local.common_resources.cores
    core_fraction = local.common_resources.core_fraction
    memory        = local.common_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = local.ubuntu_image_id
      size     = local.common_resources.disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public_b.id
    nat                = true  # внешний IP
    security_group_ids = [yandex_vpc_security_group.bastion.id]
  }

  metadata = {
    ssh-keys = "kilfords:${file("~/.ssh/id_rsa.pub")}"
  }
}
