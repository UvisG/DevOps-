terraform {
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = "3.2.3"
    }
  }
}

provider "dns" {
  update {
    server        = "192.168.0.5"
    key_name      = "terraform-key."
    key_algorithm = "hmac-sha256"
    key_secret    = var.dns_update_key
  }
}


locals {
  home_a_records = {
    router  = ["192.168.0.200"]
    proxmox = ["192.168.0.201"]
    laptop  = ["192.168.0.203"]
  }
}

resource "dns_a_record_set" "home" {
  for_each = local.home_a_records

  zone      = "kubectl.local."
  name      = each.key
  addresses = each.value
  ttl       = 3600
}