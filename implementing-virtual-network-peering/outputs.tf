output "my_public_ip" {
  value = data.external.myipaddr.result.ip
}

output "vm_1_public_ip" {
  value = azurerm_linux_virtual_machine.vm_1.public_ip_address
}

output "vm_1_private_ip" {
  value = azurerm_linux_virtual_machine.vm_1.private_ip_address
}

output "vm_2_public_ip" {
  value = azurerm_linux_virtual_machine.vm_2.public_ip_address
}

output "vm_2_private_ip" {
  value = azurerm_linux_virtual_machine.vm_2.private_ip_address
}