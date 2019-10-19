# Get private ip of VM instance inside VMSS,
# because retrieving the Private IP Addresses of instances within a VM Scale Set isn't supported by Terraform
data "external" "vmss_private_ip" {
  program = ["bash", "program/get_private_ip.sh"]

  query = {
    # arbitrary map from strings to strings, passed
    # to the external program as the data query.
    rg   = var.resource_group_name
    vmss = azurerm_virtual_machine_scale_set.vmss.name
  }
}
