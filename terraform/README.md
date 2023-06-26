# terraform

## Pre-requisites

This area assumes that you've installed the [terraform](https://developer.hashicorp.com/terraform/downloads) binary...

```shell
task tooling:install-terraform
```

## Directory layout

```sh
📂 terraform
├─📁 azure
│ └─📁 terraform-state    # Provisions Azure-backed State Storage (if using, run before any other Terraform deployments)
├─📁 cloudflare
│ ├─📁 private-domain     # Provisions all of the DNS records required under my private domain
│ └─📁 public-domain      # Provisions all of the DNS records required under my public domain
└─📁 oracle
  └─📁 free-account       # Coming soon!
```

## Azure

The Terraform state files are stored in an Azure Storage Account backend, so that I can share the state across environments and CI/CD pipelines.

If you plan to handle Terraform state in a similar manner using Azure, you'll need to at-least provision the `azure-provisioning` set of terraform files.

## Cloudflare

Currently used for DNS Zones and Domain Registrar.

### API Token

The Cloudflare files require an API Token that has `Zone` -> `DNS` -> `Edit` permission to allow DNS Records to be added / deleted / updated.

### Importing existing records

```shell
terraform import cloudflare_record.<resource_name> <zone id>/<record id>
```

Note: Being new to Cloudflare recently, the fastest way I found to grab the record ids was to open F12 Dev Tools to the Network tab for XHR, then load the DNS -> Records page, and look for a call to `https://dash.cloudflare.com/api/v4/zones/<zone id>/dns_records?per_page=50`

## Oracle

Coming soon! I plan to introduce some of the Oracle Cloud Free Account tier resources here, such as ARM-based Compute.

## References

* https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
* https://registry.terraform.io/providers/hashicorp/azurerm/latest
* https://developer.hashicorp.com/terraform/language/values/variables
* https://developer.hashicorp.com/terraform/language/values/locals
* https://developer.hashicorp.com/terraform/language/functions/regexall
* https://dev.to/drewmullen/terraform-variable-validation-with-samples-1ank
