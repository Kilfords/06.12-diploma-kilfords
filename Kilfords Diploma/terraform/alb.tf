resource "yandex_alb_target_group" "web" {
  name = "tg-web"

  target {
    subnet_id  = yandex_vpc_subnet.private_web_a.id
    ip_address = yandex_compute_instance.web1.network_interface[0].ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.private_web_b.id
    ip_address = yandex_compute_instance.web2.network_interface[0].ip_address
  }
}

resource "yandex_alb_backend_group" "web" {
  name = "bg-web"

  http_backend {
    name             = "backend1"
    port             = 80
    target_group_ids = [yandex_alb_target_group.web.id]

    healthcheck {
      timeout  = "1s"
      interval = "5s"

      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "web" {
  name = "router-web"
}

resource "yandex_alb_virtual_host" "web" {
  name           = "vh-web"
  http_router_id = yandex_alb_http_router.web.id
  route {
    name = "route-all"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web.id
      }
    }

    # путь /*
    matcher {
      http_match {
        path {
          prefix = "/"
        }
      }
    }
  }
}

resource "yandex_alb_load_balancer" "web" {
  name       = "alb-web"
  network_id = yandex_vpc_network.this.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public_a.id
    }
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.public_b.id
    }
  }

  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {}   # ALB с внешним IP
      }
      ports = [80]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.web.id
      }
    }
  }

  security_group_ids = [yandex_vpc_security_group.alb.id]
}
