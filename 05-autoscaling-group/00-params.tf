# parms file for azure clou

# Set number of instance
variable "autoscaling_http" {
  default = {
    desired_capacity = "2"
    max_size         = "5"
    min_size         = "2"
  }
}

variable "autoscaling_db" {
  default = {
    desired_capacity = "3"
    max_size         = "5"
    min_size         = "3"
  }
}
