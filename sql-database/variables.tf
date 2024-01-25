variable "admin_username" {
  description = "The administrator username of the SQL logical server."
  type        = string
  default     = "azureadmin"
}

variable "resource_group_location" {
  description = "Location for all resources."
  type        = string
  default     = "eastus"
}

variable "sql_db_name" {
  description = "The name of the SQL Database."
  type        = string
  default     = "SampleDB"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
}

