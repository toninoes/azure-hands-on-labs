locals {
  my_ip = data.external.myipaddr.result.ip
  tags = {
    CreatedBy   = "azure-hands-on-labs"
    Environment = "sandbox"
    Owner       = "toni"
  }
}
