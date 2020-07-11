locals {
  src_ip_allow_list = compact(concat(split("\n", data.http.cloudflare_ips_ipv4.body), split("\n", data.http.cloudflare_ips_ipv6.body), var.supplemental_src_ip_allow_list))
  website_block = {
    redirect_site = [{
      redirect_all_requests_to = var.redirect_to
    }]

    static_site = [{
      index_document = "index.html"
      error_document = "error.html"
      routing_rules  = var.routing_rules
    }]
  }
}

data "http" "cloudflare_ips_ipv4" {
  url = "https://www.cloudflare.com/ips-v4"
}

data "http" "cloudflare_ips_ipv6" {
  url = "https://www.cloudflare.com/ips-v6"
}
