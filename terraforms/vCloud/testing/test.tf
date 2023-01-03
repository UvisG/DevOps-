terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = "3.7.0"
    }
  }
}

# variables
variable "vcd_user" {}
variable "vcd_pass" {}
variable "vcd_org" {}
variable "vcd_vdc" {}
variable "vcd_url" {}
variable "vcd_allow_unverified_ssl" {
    default = true
}

# Configure the VMware vCloud Director Provider
provider "vcd" {
  user                 = var.vcd_user
  password             = var.vcd_pass
  org                  = var.vcd_org
  vdc                  = var.vcd_vdc
  url                  = var.vcd_url
  allow_unverified_ssl = var.vcd_allow_unverified_ssl
}

data "vcd_network_routed" "net" {
  org  = "UVGR_UVGR12" # Optional
  vdc  = "vdc_UVGR_UVGR12_01" # Optional
  name = "net_UVGR_UVGR12_IR01"
}

output "edge_gateway" {
  value = data.vcd_network_routed.net.edge_gateway
}

output "gateway" {
  value = data.vcd_network_routed.net.gateway
}
output "dhcp_start_address" {
  value = tolist(data.vcd_network_routed.net.dhcp_pool)[0].start_address
}

output "dhcp_end_address" {
  value = tolist(data.vcd_network_routed.net.dhcp_pool)[0].end_address
}
