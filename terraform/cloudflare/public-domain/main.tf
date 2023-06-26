terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "rg-tenant-provisioning"
  #   storage_account_name = "satenantprovisioningjpg"
  #   container_name       = "terraform-state-files"
  #   key                  = "terraform-azure-provisioning.tfstate"
  # }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

locals {
  domain_key = replace(var.domain_name, ".", "-")
}

resource "cloudflare_record" "cname_autodiscover" {
  zone_id = var.cloudflare_zone_id
  name    = "autodiscover"
  type    = "CNAME"

  value   = "autodiscover.outlook.com"
  comment = "Microsoft Exchange - Client Auto-Discovery"
  tags    = toset([
    "Production",
    "Microsoft Office 365",
    "Microsoft Exchange",
    "Client Auto-Discovery"
  ])
}

resource "cloudflare_record" "cname_enterpriseenrollment" {
  zone_id = var.cloudflare_zone_id
  name    = "enterpriseenrollment"
  type    = "CNAME"

  value   = "enterpriseenrollment.manage.microsoft.com"
  comment = "Azure Active Directory (AAD) - Mobile Device Management (MDM) Enrollment"
  tags    = toset([
    "Production",
    "Microsoft Azure",
    "Azure Active Directory (AAD)",
    "Mobile Device Management (MDM) Enrollment"
  ])
}

resource "cloudflare_record" "cname_enterpriseregistration" {
  zone_id = var.cloudflare_zone_id
  name    = "enterpriseregistration"
  type    = "CNAME"

  value   = "enterpriseregistration.windows.net"
  comment = "Azure Active Directory (AAD) - Mobile Device Management (MDM) Registration"
  tags    = toset([
    "Production",
    "Microsoft Azure",
    "Azure Active Directory (AAD)",
    "Mobile Device Management (MDM) Registration"
  ])
}

resource "cloudflare_record" "cname_domain_apex" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "CNAME"

  value   = "justingarfield.github.io"
  comment = "Jekyll Static Site - Personal Site"
  tags    = toset([
    "Production",
    "GitHub Pages",
    "Jekyll Static Site",
    "Personal website"
  ])
  proxied = true
}

resource "cloudflare_record" "cname_lyncdiscover" {
  zone_id = var.cloudflare_zone_id
  name    = "lyncdiscover"
  type    = "CNAME"

  value   = "webdir.online.lync.com"
  comment = "Skype for Business Online - Web Directory and Teams-only Support"
  tags    = toset([
    "Production",
    "Microsoft Office 365",
    "Skype for Business Online",
    "Web Directory and Teams-only Support"
  ])
}

resource "cloudflare_record" "cname_dkim_selector1" {
  zone_id = var.cloudflare_zone_id
  name    = "selector1._domainkey"
  type    = "CNAME"

  value   = "selector1-${local.domain_key}._domainkey.${var.onmicrosoft_domain_name}.onmicrosoft.com"
  comment = "Microsoft Exchange - DKIM"
  tags    = toset([
    "Production",
    "Microsoft Office 365",
    "Microsoft Exchange",
    "DKIM"
  ])
}

resource "cloudflare_record" "cname_dkim_selector2" {
  zone_id = var.cloudflare_zone_id
  name    = "selector2._domainkey"
  type    = "CNAME"

  value   = "selector2-${local.domain_key}._domainkey.${var.onmicrosoft_domain_name}.onmicrosoft.com"
  comment = "Microsoft Exchange - DKIM"
  tags    = toset([
    "Production",
    "Microsoft Office 365",
    "Microsoft Exchange",
    "DKIM"
  ])
}

resource "cloudflare_record" "cname_sip" {
  zone_id = var.cloudflare_zone_id
  name    = "sip"
  type    = "CNAME"

  value   = "sipdir.online.lync.com"
  comment = "Skype for Business Online - SIP Directory and Teams-only Support"
  tags    = toset([
    "Production",
    "Microsoft Office 365",
    "Skype for Business Online",
    "Web Directory and Teams-only Support"
  ])
}

resource "cloudflare_record" "cname_www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "CNAME"

  value   = "justingarfield.github.io"
  comment = "Jekyll Static Site - Personal Site"
  tags    = toset([
    "Production",
    "GitHub Pages",
    "Jekyll Static Site",
    "Personal website"
  ])
  proxied = true
}

resource "cloudflare_record" "mx_domain_apex" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "MX"

  value   = "${local.domain_key}.mail.protection.outlook.com"
  comment = "Microsoft Exchange - Mail exchanger"
  tags    = toset([
    "Production",
    "Microsoft Office 365",
    "Microsoft Exchange",
    "Mail exchanger"
  ])
}

resource "cloudflare_record" "srv__sipfederationtls_tcp" {
  zone_id = var.cloudflare_zone_id
  name    = "_sipfederationtls._tcp"
  type    = "SRV"

  data {
    service  = "_sipfederationtls"
    proto    = "_tcp"
    name     = "@"
    priority = 100
    weight   = 1
    port     = 5061
    target   = "sipfed.online.lync.com"
  }
  comment = "Skype for Business Online - SIP Federation"
  tags    = toset([
    "Production",
    "Microsoft Office 365",
    "Skype for Business Online",
    "SIP Federation"
  ])
}

resource "cloudflare_record" "srv__sip_tls" {
  zone_id = var.cloudflare_zone_id
  name    = "_sip._tls"
  type    = "SRV"

  data {
    service  = "_sip"
    proto    = "_tls"
    name     = "@"
    priority = 100
    weight   = 1
    port     = 443
    target   = "sipdir.online.lync.com"
  }
  comment = "Skype for Business Online - SIP TLS"
  tags    = toset([
    "Production",
    "Microsoft Office 365",
    "Skype for Business Online",
    "SIP TLS"
  ])
}

resource "cloudflare_record" "txt__dmarc" {
  zone_id = var.cloudflare_zone_id
  name    = "_dmarc"
  type    = "TXT"

  value   = "v=DMARC1; p=none; rua=mailto:admin@${var.domain_name}; ruf=mailto:admin@${var.domain_name}; fo=1"
  comment = "Microsoft Exchange - DMARC"
  tags    = toset([
    "Production",
    "Microsoft Office 365",
    "Microsoft Exchange",
    "DMARC"
  ])
}

resource "cloudflare_record" "txt_domain_apex" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "TXT"

  value   = "v=spf1 include:_spf.mailersend.net include:spf.protection.outlook.com ~all"
  comment = "Microsoft Exchange - SPF"
  tags    = toset([
    "Production",
    "Microsoft Office 365",
    "Microsoft Exchange",
    "SPF"
  ])
}
