output "url_staging" {
  description = "Url for Staging slot."
  value       = module.my_app.webapp_slot_url
}

output "url_production" {
  description = "Url for Production slot."
  value       = module.my_app.webapp_url
}
