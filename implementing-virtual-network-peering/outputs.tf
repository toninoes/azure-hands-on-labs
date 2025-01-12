output "my_public_ip" {
  description = "My public IP. Only to test that NSG are properly defined."
  value       = data.external.myipaddr.result.ip
}

output "vm_0_access" {
  description = "SSH command to access to VM-0"
  value       = "ssh -i ${var.ssh_key_pairs_name}.pem ${var.admin_username}@${azurerm_linux_virtual_machine.this[0].public_ip_address}"
}

output "vm_0_testing_connection_to_vm_1" {
  description = "PING command to test connectivity through peer connection to VM-1"
  value       = "ping ${azurerm_linux_virtual_machine.this[1].private_ip_address}"
}

output "vm_1_access" {
  description = "SSH command to access to VM-1"
  value       = "ssh -i ${var.ssh_key_pairs_name}.pem ${var.admin_username}@${azurerm_linux_virtual_machine.this[1].public_ip_address}"
}

output "vm_1_testing_connection_to_vm_0" {
  description = "PING command to test connectivity through peer connection to VM-0"
  value       = "ping ${azurerm_linux_virtual_machine.this[0].private_ip_address}"
}