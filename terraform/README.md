# terraform

## Pre-requisites

This area assumes that you've installed the [terraform](https://developer.hashicorp.com/terraform/downloads) binary...

```shell
task tooling:install-terraform
```

## Directory layout

```sh
📂 terraform
├─📁 azure-provisioning
└─📁 cloudflare
  ├─📁 private-domain
  │ ├─📄 main.tf          # Provisions all of the DNS records required under my private domain
  │ └─📄 variables.tf     # Variables and validation required for main.tf to function properly
  └─📁 public-domain
    ├─📄 main.tf          # Provisions all of the DNS records required under my public domain
    └─📄 variables.tf     # Variables and validation required for main.tf to function properly
```

## References

* https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
* https://registry.terraform.io/providers/hashicorp/azurerm/latest
* https://developer.hashicorp.com/terraform/language/values/variables
* https://developer.hashicorp.com/terraform/language/values/locals
* https://developer.hashicorp.com/terraform/language/functions/regexall
* https://dev.to/drewmullen/terraform-variable-validation-with-samples-1ank
