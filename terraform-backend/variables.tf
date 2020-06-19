variable "prefix" {
  type        = string
  default     = ""
  description = "Prefix applied to resources created by this module"
}

variable "s3_bucket_suffix" {
  type        = string
  default     = ""
  description = "Since S3 bucket names are globally unique, you are advised to attach a suffix"
}

variable "tags" {
  type = map
  default = {
    managed-by = "terraform"
  }
}
