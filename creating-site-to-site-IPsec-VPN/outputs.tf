output "vm_0_access" {
  description = "SSH command to access to VM-0"
  value       = "ssh -i ${module.vm_0.ssh_key_private_name} ${var.admin_username}@${module.vm_0.public_ip}"
}

output "vm_0_testing_connection_to_vm_on_prem" {
  description = "PING command to test connectivity through Site-to-Site IPsec VPN connection to VM-onprem"
  value       = "ping ${module.vm_onprem.private_ip}"
}

output "vm_onprem_access" {
  description = "SSH command to access to VM-Onprem"
  value       = "ssh -i ${module.vm_onprem.ssh_key_private_name} ${var.admin_username}@${module.vm_onprem.public_ip}"
}

output "vm_onprem_testing_connection_to_vm_0" {
  description = "PING command to test connectivity through Site-to-Site IPsec VPN connection to VM-0"
  value       = "ping ${module.vm_0.private_ip}"
}