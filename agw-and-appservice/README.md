# Application Gateway & App Service

Simple configuration to deploy an Application Gateway listening on 443 port (SSL Let's Encrypt) and a simple App Service as Backend.

## Get Let's Encrypt certificate

Execute this commands:

Install certbot:

```bash
sudo apt update
sudo apt install certbot
```

Create certificate:

```bash
certbot certonly --manual --preferred-challenges dns -d *.toninoes.es -d toninoes.es
```

You will need to validate a TXT file in your DNS, im my case Godaddy.

Finally create .pfx file:

```bash
openssl pkcs12 -export -out certificado.pfx -inkey privkey1.pem -in cert1.pem -certfile chain1.pem
```

You will need to configure a password linked with this .pfx file. Remember to configure in listener later.

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| azurerm | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | 4.15.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_linux_web_app.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_subnet.agw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.pep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource\_group\_name | Resource group where to deploy. | `string` | n/a | yes |

## Outputs

No outputs.
