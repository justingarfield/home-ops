terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  # Set using CLOUDFLARE_API_TOKEN env var instead
  # api_token = var.cloudflare_api_token
}

resource "cloudflare_record" "cname_autodiscover" {
  zone_id = var.cloudflare_zone_id
  name    = "autodiscover"
  type    = "CNAME"

  value   = "autodiscover.outlook.com"
  comment = "Office 365"
  tags    = "o365 microsoft office"
}

resource "cloudflare_record" "cname_enterpriseenrollment" {
  zone_id = var.cloudflare_zone_id
  name    = "enterpriseenrollment"
  type    = "CNAME"

  value   = "enterpriseenrollment.manage.microsoft.com"
  comment = "Office 365"
  tags    = "o365 microsoft office"
}

resource "cloudflare_record" "cname_enterpriseregistration" {
  zone_id = var.cloudflare_zone_id
  name    = "enterpriseregistration"
  type    = "CNAME"

  value   = "enterpriseregistration.windows.net"
  comment = "Office 365"
  tags    = "o365 microsoft office"
}

resource "cloudflare_record" "cname_domain_apex" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "CNAME"

  value   = "justingarfield.github.io"
  comment = "Personal Site"
  tags    = "web site github pages"
  proxied = true
}

resource "cloudflare_record" "cname_lyncdiscover" {
  zone_id = var.cloudflare_zone_id
  name    = "lyncdiscover"
  type    = "CNAME"

  value   = "webdir.online.lync.com"
  comment = "Office 365"
  tags    = "o365 microsoft office"
}

resource "cloudflare_record" "cname_dkim_selector1" {
  zone_id = var.cloudflare_zone_id
  name    = "selector1._domainkey"
  type    = "CNAME"

  value   = "selector1-jgarfield-com._domainkey.jgarfield.onmicrosoft.com"
  comment = "DKIM"
  tags    = "email protection"
}

resource "cloudflare_record" "cname_dkim_selector2" {
  zone_id = var.cloudflare_zone_id
  name    = "selector2._domainkey"
  type    = "CNAME"

  value   = "selector2-jgarfield-com._domainkey.jgarfield.onmicrosoft.com"
  comment = "DKIM"
  tags    = "email protection"
}

resource "cloudflare_record" "cname_sip" {
  zone_id = var.cloudflare_zone_id
  name    = "sip"
  type    = "CNAME"

  value   = "sipdir.online.lync.com"
  comment = "Office 365"
  tags    = "o365 microsoft office"
}

resource "cloudflare_record" "cname_www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "CNAME"

  value   = "justingarfield.github.io"
  comment = "Personal Site"
  tags    = "web site github pages"
  proxied = true
}

resource "cloudflare_record" "mx_domain_apex" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "MX"

  value   = "jgarfield-com.mail.protection.outlook.com"
  comment = "Office 365"
  tags    = "o365 microsoft office email exchange"
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
  comment = "Office 365"
  tags    = "o365 microsoft office"
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
  comment = "Office 365"
  tags    = "o365 microsoft office"
}

resource "cloudflare_record" "txt__dmarc" {
  zone_id = var.cloudflare_zone_id
  name    = "_dmarc"
  type    = "TXT"

  value   = "v=DMARC1; p=none; rua=mailto:dmarc-aggregate@jgarfield.com; ruf=mailto:dmarc-failure@jgarfield.com; fo=1"
  comment = "DMARC"
  tags    = "email protection"
}

resource "cloudflare_record" "txt_domain_apex" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "TXT"

  value   = "v=spf1 include:_spf.mailersend.net include:spf.protection.outlook.com ~all"
  comment = "SPF"
  tags    = "email protection"
}
