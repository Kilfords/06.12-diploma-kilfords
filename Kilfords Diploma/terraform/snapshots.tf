resource "yandex_compute_snapshot_schedule" "daily" {
  name = "daily-vm-snapshots"

  schedule_policy {
    # каждый день в 03:00 UTC
    expression = "0 3 * * *"
  }

  # время жизни снимков 7 дней
  retention_period = "168h" # 7 * 24h

  snapshot_spec {
    description = "Daily snapshot by Terraform"
    labels = {
      env = "diploma"
    }
  }

  # все boot-диски ВМ
  disk_ids = [
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
    yandex_compute_instance.web1.boot_disk[0].disk_id,
    yandex_compute_instance.web2.boot_disk[0].disk_id,
    yandex_compute_instance.zabbix.boot_disk[0].disk_id,
    yandex_compute_instance.elasticsearch.boot_disk[0].disk_id,
    yandex_compute_instance.kibana.boot_disk[0].disk_id,
  ]
}
