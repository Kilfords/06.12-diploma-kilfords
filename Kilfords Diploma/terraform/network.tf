resource "yandex_vpc_network" "this" {
  name = var.vpc_name
}

# Публичные подсети (a, b)
resource "yandex_vpc_subnet" "public_a" {
  name           = "public-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "public_b" {
  name           = "public-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

# Приватные подсети для web
resource "yandex_vpc_subnet" "private_web_a" {
  name           = "private-web-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = ["10.0.11.0/24"]
  route_table_id = yandex_vpc_route_table.private_rt.id
}

resource "yandex_vpc_subnet" "private_web_b" {
  name           = "private-web-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = ["10.0.12.0/24"]
  route_table_id = yandex_vpc_route_table.private_rt.id
}

# Приватная подсеть для Elasticsearch
resource "yandex_vpc_subnet" "private_es" {
  name           = "private-es-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = ["10.0.21.0/24"]
  route_table_id = yandex_vpc_route_table.private_rt.id
}

# NAT + таблица маршрутов для выхода приватных сетей в интернет
resource "yandex_vpc_gateway" "nat" {
  name = "nat-gw"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private_rt" {
  name       = "private-rt"
  network_id = yandex_vpc_network.this.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat.id
  }
}
