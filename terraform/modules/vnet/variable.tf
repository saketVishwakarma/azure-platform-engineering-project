variable "vnet_name" {}
variable "location" {}
variable "rg_name" {}

variable "subnets" {
  type = map(string)
}