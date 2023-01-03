# variables.tf
# Declare all the variables needed
variable "vcd_user" {
    type = string
}
variable "vcd_pass" {
    type = string
}
variable "vcd_org" {
    type = string
}
variable "vcd_vdc" {
    type = string
}
variable "vcd_url" {
    type = string
}
variable "vcd_allow_unverified_ssl" {
    type = string
}

###vCD variables for deployment
variable "vapp" {
    type = string
}
variable "vapp_org_net_name" {
    type = string
}
variable "control-count" {
    type = string
    description = "Number of Control VM's"
    default     =  3
}
variable "vm-prefix" {
    type = string
}
variable "worker-count" {
    type = string
    description = "Number of Worker VM's"
    default     =  3
}




#####UVIS CONFIG END#########


/*









variable "vsphere-unverified-ssl" {
    type = string
}

variable "vsphere-cluster" {
    type = string
    default = ""
}
variable "control-count" {
    type = string
    description = "Number of Control VM's"
    default     =  3
}

}
variable "vm-datastore" {
    type = string
}
variable "vm-network" {
    type = string
}
variable "vm-cpu" {
    type = string
    default = "2"
}
variable "vm-ram" {
    type = string
}

variable "vm-guest-id" {
    type = string
}
variable "vm-template-name" {
    type = string
}
variable "vm-domain" {
    type = string
}

*/