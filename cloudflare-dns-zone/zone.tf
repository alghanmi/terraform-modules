resource "cloudflare_zone" "zone" {
  zone = var.cloudflare_domain
}

resource "cloudflare_zone_settings_override" "zone" {
  zone_id = cloudflare_zone.zone.id
  settings {
    always_use_https         = "on"
    automatic_https_rewrites = "on"
    brotli                   = "on"
    http3                    = "off"
    ipv6                     = "on"
    min_tls_version          = "1.2"
    ssl                      = "strict"
    tls_1_3                  = "on"
    websockets               = "on"
    minify {
      css  = "on"
      html = "on"
      js   = "off"
    }
  }
}
