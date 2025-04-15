variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "instance-type" {
  type        = string
  description = "the instance family like t2.micro, m5.large, r5.xlarge"
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "the name of an already created ssh key pair"
  default     = ""
}
