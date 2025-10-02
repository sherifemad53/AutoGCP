# Variables for bucket module

variable "bucket_name" { 
    type = string
    default = "bucket-test"
}
variable "region"      { type = string }
variable "project" {
    type = string
}