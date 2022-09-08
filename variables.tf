variable "suffix" {
  description = "Suffix to add to created resources."
  type        = string
  default     = "example"
}

variable "region" {
  description = "Region to bring up Exafunction infrastructure in."
  type        = string
  default     = "us-west-1"
}
