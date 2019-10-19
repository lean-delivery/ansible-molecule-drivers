locals {
  tags = {
    Name         = var.tag_name
    Instance     = var.tag_instance
    OS           = var.tag_os
    Managed_by   = "Molecule"
    Created_time = timestamp()
  }

  # For dynamic argument block for Linux nodes only
  ssh_keys = [
    {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = var.ssh_public_key
    }
  ]

  # For dynamic argument block for Windows nodes only
  windows_config = [
    {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
    }
  ]

  # For dynamic argument block for Windows nodes only
  windows_extension = [
    {
      name                       = "winrm-extension"
      publisher                  = "Microsoft.Compute"
      type                       = "CustomScriptExtension"
      type_handler_version       = "1.9"
      auto_upgrade_minor_version = true
      settings                   = <<-EOT
            {"commandToExecute": "powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1 -EnableCredSSP",
            "fileUris": ["https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"]}
            EOT
    }
  ]
}