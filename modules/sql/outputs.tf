# Outputs for sql module

output "db_connection_name" {
  value = google_sql_database_instance.default.connection_name
}
