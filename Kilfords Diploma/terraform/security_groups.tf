resource "yandex_vpc_security_group" "web" {
  name       = "web-sg"
  network_id = yandex_vpc_network.this.id

  # вход: HTTP только от ALB
  ingress {
    protocol          = "TCP"
    description       = "HTTP from ALB"
    port              = 80
    security_group_id = yandex_vpc_security_group.alb.id
  }

  # вход: SSH только от bastion
  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }

  # исход: всё наружу (через NAT)
  egress {
    protocol       = "ANY"
    description    = "Any outbound"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "alb" {
  name       = "alb-sg"
  network_id = yandex_vpc_network.this.id

  # вход с интернета на 80
  ingress {
    protocol       = "TCP"
    description    = "HTTP from internet"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # исходящий трафик на web-сервера
  egress {
    protocol          = "TCP"
    description       = "HTTP to web SG"
    port              = 80
    security_group_id = yandex_vpc_security_group.web.id
  }
}
