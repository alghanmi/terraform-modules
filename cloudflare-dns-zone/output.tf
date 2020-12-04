output "id" {
  value = cloudflare_zone.zone.id
}

output "name_servers" {
  value = cloudflare_zone.zone.name_servers
}

output "zone" {
  value = cloudflare_zone.zone.zone
}
