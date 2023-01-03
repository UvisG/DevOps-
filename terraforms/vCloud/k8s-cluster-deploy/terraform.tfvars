

# vCD configuration
vcd_user = "ug"
vcd_pass = "Rudzupuke]2x"
vcd_org = "UVGR_UVGR12"
vcd_vdc = "vdc_UVGR_UVGR12_01"
vcd_url = "https://vcd01.proact.lv/api"
vcd_allow_unverified_ssl = true

#vCD Resource config
vapp = "k8s-cluster01"
vapp_org_net_name = "net_UVGR_UVGR12_IR01"

control-count = "1"
worker-count = "3"

# VM Configuration
vm-prefix = "k8s"


# vSphere username defined in environment variable
# export TF_VAR_vsphereuser=$(pass vsphere-user)

# vSphere password defined in environment variable
# export TF_VAR_vspherepass=$(pass vsphere-password)