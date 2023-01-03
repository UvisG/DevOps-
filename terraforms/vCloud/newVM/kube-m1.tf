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

#data "vcd_network_routed" "net" {
#  name = "net_UVGR_UVGR12_IR01"
#}

data "vcd_network_routed" "net" {
  org  = "UVGR_UVGR12" # Optional
  vdc  = "vdc_UVGR_UVGR12_01" # Optional
  name = "net_UVGR_UVGR12_IR01"
}



# Create the vApp
resource "vcd_vapp" "jumphost" {
  name = "jumphost"
}

resource "vcd_vapp_org_network" "vappOrgNet" {
  org = "UVGR_UVGR12" # Optional
  vdc = "vdc_UVGR_UVGR12_01" # Optional
  vapp_name = vcd_vapp.jumphost.name

  # Comment below line to create an isolated vApp network
  org_network_name = "net_UVGR_UVGR12_IR01"
}

# Create the VM in the vApp
resource "vcd_vapp_vm" "jumphost" {
  vapp_name = vcd_vapp.jumphost.name
  name = "jumphost01"
  catalog_name = "My Catalog"
  template_name = "ubuntu-golden-image"
  
  computer_name = "jumphost01"
  memory = 4096
  cpus = 2
  cpu_cores = 1

  # Map the network from the data source to the VM
  network_dhcp_wait_seconds = 300
  network {
      name = data.vcd_network_routed.net.name
      type = "org"
      ip_allocation_mode = "DHCP"
      is_primary = true
  }

  depends_on = [vcd_vapp.jumphost]
}



data "vcd_vapp_vm" "jumphost01" {
  vapp_name = vcd_vapp.jumphost.name
  name = "jumphost01"
}

#data "vcd_vapp_vm_network" "net" {
#  vapp_name = vcd_vapp_vm.jumphost01
#  name = "net"
#}

output "vm" {
  value = data.vcd_vapp_vm.jumphost01.network.ip
}

/*
data "vcd_vapp_vm" "ip" {
  name_ip = data.vcd_vapp.jumphost01.href
  name = ip
}

data "vcd_vapp_vm" "ip" {
  name_ip = data.vcd_vapp_vm
  
}


data "vcd_vapp_vm" "net" {
  ip = data.vcd_vapp.jumphost.jumphost01.network
  name = netwo
}
data "vcd_vapp_vm" "ip" {
  ip = data.vcd_vapp_vm.jumphost01.ip
}

output "ip" {
  value = data.vcd_vapp_vm.ip
}


*/



/*





data "vcd_vapp" "jumphost" {
  name = "jumphost"
}

data "vcd_vapp_vm" "jumphost01" {
  vapp_name = data.vcd_vapp.jumphost.name
  name      = "jumphost01"
}

#output "vm_id" {
#  value = data.vcd_vapp_vm.id
#}
output "vm" {
  value = data.vcd_vapp_vm.jumphost01
} 
*/