variable "access_key" {
  type    = string
  default = ""
}

variable "secret_key" {
  type    = string
  default = ""
}

variable "vm_names" {
  type    = list(string)
  default = ["master01","master02","worker01","worker02","worker03"]
}
variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "instance_type" {
  type    = string
  default = "t2.xlarge"
}

variable "ami" {
  type    = string
  default = "ami-026f33d38b6410e30"
}

variable "key_name" {
  type    = string
  default = "myKey-cdp-demo01"
}


