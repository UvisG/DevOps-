# main.tf

# Configure the vSphere provider
terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = "3.7.0"
    }
  }
}
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

###vCloud related variables follows
#data "vcd_network_routed" "net" {
#  org  = "UVGR_UVGR12" # Optional
#  vdc  = "vdc_UVGR_UVGR12_01" # Optional
#  name = "net_UVGR_UVGR12_IR01"
#}
# Create the vApp
resource "vcd_vapp" "vcdApp" {
  name = var.vapp
}

resource "vcd_vapp_org_network" "vappOrgNet" {
  org = "UVGR_UVGR12" # Optional
  vdc = "vdc_UVGR_UVGR12_01" # Optional
  vapp_name = vcd_vapp.vcdApp.name

  # Comment below line to create an isolated vApp network
  org_network_name = var.vapp_org_net_name
}

# Create Control VMs
resource "vcd_vapp_vm" "control" {
  count = var.control-count
  vapp_name = vcd_vapp.vcdApp.name
  name = "${var.vm-prefix}-controller-${count.index + 1}"
  catalog_name = "My Catalog"
  template_name = "ubuntu-golden-image"
  
  computer_name = "${var.vm-prefix}-controller-${count.index + 1}"
  memory = 4096
  cpus = 2
  cpu_cores = 1

  network {
      name = data.vcd_network_routed.net.name
      type = "org"
      ip_allocation_mode = "DHCP"
      is_primary = true
  }

  depends_on = [vcd_vapp.vcdApp]

}

# Create Worker VMs
resource "vcd_vapp_vm" "worker" {
  count = var.worker-count
  vapp_name = vcd_vapp.vcdApp.name
  name = "${var.vm-prefix}-worker-${count.index + 1}"
  catalog_name = "My Catalog"
  template_name = "ubuntu-golden-image"
  
  computer_name = "${var.vm-prefix}-worker-${count.index + 1}"
  memory = 4096
  cpus = 2
  cpu_cores = 1

  network {
      name = data.vcd_network_routed.net.name
      type = "org"
      ip_allocation_mode = "DHCP"
      is_primary = true
  }

  depends_on = [vcd_vapp.vcdApp]

}


########UVIS CONFIG##########


/*


data "vsphere_datacenter" "dc" {
    name = var.vsphere-datacenter
}

data "vsphere_datastore" "datastore" {
    name = var.vm-datastore
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
    name = var.vsphere-cluster
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
    name = var.vm-network
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
    name = var.vm-template-name
    datacenter_id = data.vsphere_datacenter.dc.id
}

# Create VM Folder
resource "vsphere_folder" "folder" {
  path          = "k8s"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Create Control VMs
resource "vsphere_virtual_machine" "control" {
    count = var.control-count
    name = "${var.vm-prefix}-controller-${count.index + 1}"
    resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
    datastore_id = data.vsphere_datastore.datastore.id
    folder = vsphere_folder.folder.path
    
    num_cpus = var.vm-cpu
    memory = var.vm-ram
    guest_id = var.vm-guest-id

    
    network_interface {
        network_id = data.vsphere_network.network.id
    }

    disk {
        label = "${var.vm-prefix}-${count.index + 1}-disk"
        size  = 25
    }

    clone {
        template_uuid = data.vsphere_virtual_machine.template.id
        customize {
            timeout = 0
            
            linux_options {
            host_name = "${var.vm-prefix}-controller-${count.index + 1}"
            domain = var.vm-domain
            }
            
            network_interface {
            ipv4_address = "10.128.128.11${count.index + 1}"
            ipv4_netmask = 24
            }

            ipv4_gateway = "10.128.128.1"
            dns_server_list = [ "10.128.128.80" ]

        }
    }
}

# Create Worker VMs
resource "vsphere_virtual_machine" "worker" {
    count = var.worker-count
    name = "${var.vm-prefix}-worker-${count.index + 1}"
    resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
    datastore_id = data.vsphere_datastore.datastore.id
    folder = vsphere_folder.folder.path
    
    num_cpus = var.vm-cpu
    memory = var.vm-ram
    guest_id = var.vm-guest-id
    
    network_interface {
        network_id = data.vsphere_network.network.id
    }

    disk {
        label = "${var.vm-prefix}-${count.index + 1}-disk"
        size  = 25
    }

    clone {
        template_uuid = data.vsphere_virtual_machine.template.id
        customize {
            timeout = 0
            
            linux_options {
            host_name = "${var.vm-prefix}-worker-${count.index + 1}"
            domain = var.vm-domain
            }
            
            network_interface {
            ipv4_address = "10.128.128.12${count.index + 1}"
            ipv4_netmask = 24
            }

            ipv4_gateway = "10.128.128.1"
            dns_server_list = [ "10.128.128.80" ]
        }
    }
}

output "control_ip_addresses" {
 value = vsphere_virtual_machine.control.*.default_ip_address
}

output "worker_ip_addresses" {
 value = vsphere_virtual_machine.worker.*.default_ip_address
}
*/