output "vmss_id" {
  value = azurerm_virtual_machine_scale_set.vmss.id
}

output "vmss_name" {
  value = azurerm_virtual_machine_scale_set.vmss.name
}

output "vmss_public_fqdn" {
  value = azurerm_public_ip.vmss-ip.fqdn
}

output "vmss_tag_name" {
  value = azurerm_virtual_machine_scale_set.vmss.tags.Name
}

output "vmss_tag_instance" {
  value = azurerm_virtual_machine_scale_set.vmss.tags.Instance
}

output "vmss_private_ip" {
  value = data.external.vmss_private_ip.result.ip
}