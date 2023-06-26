terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.8.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "jpg-home-ops-terraform"
    container_name       = "terraform-state-files"
    key                  = "azure-public-domain.tfstate"
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

locals {
  # turns "domain.com" into "domain-com"
  domain_key = replace(var.domain_name, ".", "-")

  # removes ".onmicrosoft.com" suffix if it was included
  onmicrosoft = replace(var.onmicrosoft_domain_name, ".onmicrosoft.com", "")
}

resource "cloudflare_record" "cname_autodiscover" {
  zone_id = var.cloudflare_zone_id
  name    = "autodiscover"
  type    = "CNAME"

  value   = "autodiscover.outlook.com"
  comment = "Microsoft Exchange - Client Auto-Discovery"
  # tags    = toset([
  #   "production",
  #   "microsoft-office-365",
  #   "microsoft-exchange",
  #   "client-auto-discovery"
  # ])
}

resource "cloudflare_record" "cname_enterpriseenrollment" {
  zone_id = var.cloudflare_zone_id
  name    = "enterpriseenrollment"
  type    = "CNAME"

  value   = "enterpriseenrollment-s.manage.microsoft.com"
  comment = "Azure Active Directory (AAD) - Mobile Device Management (MDM) Enrollment"
  # tags    = toset([
  #   "production",
  #   "microsoft-azure",
  #   "azure-active-directory",
  #   "mobile-device-management"
  # ])
}

resource "cloudflare_record" "cname_enterpriseregistration" {
  zone_id = var.cloudflare_zone_id
  name    = "enterpriseregistration"
  type    = "CNAME"

  value   = "enterpriseregistration.windows.net"
  comment = "Azure Active Directory (AAD) - Mobile Device Management (MDM) Registration"
  # tags    = toset([
  #   "production",
  #   "microsoft-azure",
  #   "azure-active-directory",
  #   "mobile-device-management"
  # ])
}

resource "cloudflare_record" "cname_domain_apex" {
  zone_id = var.cloudflare_zone_id
  name    = "${var.domain_name}"
  type    = "CNAME"

  value   = "justingarfield.github.io"
  comment = "Jekyll Static Site - Personal Site"
  proxied = true
  # tags    = toset([
  #   "production",
  #   "github-pages",
  #   "jekyll-static-site",
  #   "personal-website"
  # ])
}

resource "cloudflare_record" "cname_lyncdiscover" {
  zone_id = var.cloudflare_zone_id
  name    = "lyncdiscover"
  type    = "CNAME"

  value   = "webdir.online.lync.com"
  comment = "Skype for Business Online - Web Directory and Teams-only Support"
  # tags    = toset([
  #   "production",
  #   "microsoft-office-365",
  #   "skype-for-business-online",
  #   "web-directory_and_teams-only_support"
  # ])
}

resource "cloudflare_record" "cname_dkim_selector1" {
  zone_id = var.cloudflare_zone_id
  name    = "selector1._domainkey"
  type    = "CNAME"

  value   = "selector1-${local.domain_key}._domainkey.${local.onmicrosoft}.onmicrosoft.com"
  comment = "Microsoft Exchange - DKIM"
  # tags    = toset([
  #   "production",
  #   "microsoft-office-365",
  #   "microsoft-exchange",
  #   "dkim"
  # ])
}

resource "cloudflare_record" "cname_dkim_selector2" {
  zone_id = var.cloudflare_zone_id
  name    = "selector2._domainkey"
  type    = "CNAME"

  value   = "selector2-${local.domain_key}._domainkey.${local.onmicrosoft}.onmicrosoft.com"
  comment = "Microsoft Exchange - DKIM"
  # tags    = toset([
  #   "production",
  #   "microsoft-office-365",
  #   "microsoft-exchange",
  #   "dkim"
  # ])
}

resource "cloudflare_record" "cname_sip" {
  zone_id = var.cloudflare_zone_id
  name    = "sip"
  type    = "CNAME"

  value   = "sipdir.online.lync.com"
  comment = "Skype for Business Online - SIP Directory and Teams-only Support"
  # tags    = toset([
  #   "production",
  #   "microsoft-office-365",
  #   "skype-for-business-online",
  #   "web-directory_and_teams-only_support"
  # ])
}

resource "cloudflare_record" "cname_www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "CNAME"

  value   = "justingarfield.github.io"
  comment = "Jekyll Static Site - Personal Site"
  proxied = true
  # tags    = toset([
  #   "production",
  #   "github-pages",
  #   "jekyll-static-site",
  #   "personal-website"
  # ])
}

resource "cloudflare_record" "mx_domain_apex" {
  zone_id  = var.cloudflare_zone_id
  name     = "${var.domain_name}"
  type     = "MX"

  value    = "${local.domain_key}.mail.protection.outlook.com"
  comment  = "Microsoft Exchange - Mail exchanger"
  priority = 0
  # tags     = toset([
  #   "production",
  #   "microsoft-office-365",
  #   "microsoft-exchange",
  #   "mail-exchanger"
  # ])
}

resource "cloudflare_record" "srv__sipfederationtls_tcp" {
  zone_id = var.cloudflare_zone_id
  name    = "_sipfederationtls._tcp"
  type    = "SRV"

  data {
    service  = "_sipfederationtls"
    proto    = "_tcp"
    name     = "${var.domain_name}"
    priority = 100
    weight   = 1
    port     = 5061
    target   = "sipfed.online.lync.com"
  }
  comment = "Skype for Business Online - SIP Federation"
  # tags    = toset([
  #   "production",
  #   "microsoft-office-365",
  #   "skype-for-business-online",
  #   "sip-federation"
  # ])
}

resource "cloudflare_record" "srv__sip_tls" {
  zone_id = var.cloudflare_zone_id
  name    = "_sip._tls"
  type    = "SRV"

  data {
    service  = "_sip"
    proto    = "_tls"
    name     = "${var.domain_name}"
    priority = 100
    weight   = 1
    port     = 443
    target   = "sipdir.online.lync.com"
  }
  comment = "Skype for Business Online - SIP TLS"
  # tags    = toset([
  #   "production",
  #   "microsoft-office-365",
  #   "skype-for-business-online",
  #   "sip-tls"
  # ])
}

resource "cloudflare_record" "txt__dmarc" {
  zone_id = var.cloudflare_zone_id
  name    = "_dmarc"
  type    = "TXT"

  value   = "v=DMARC1; p=none; rua=mailto:admin@${var.domain_name}; ruf=mailto:admin@${var.domain_name}; fo=1"
  comment = "Microsoft Exchange - DMARC"
  # tags    = toset([
  #   "production",
  #   "microsoft-office-365",
  #   "microsoft-exchange",
  #   "dmarc"
  # ])
}

resource "cloudflare_record" "txt_domain_apex" {
  zone_id = var.cloudflare_zone_id
  name    = "${var.domain_name}"
  type    = "TXT"

  value   = "v=spf1 include:_spf.mailersend.net include:spf.protection.outlook.com ~all"
  comment = "Microsoft Exchange - SPF"
  # tags    = toset([
  #   "production",
  #   "microsoft-office-365",
  #   "microsoft-exchange",
  #   "spf"
  # ])
}
