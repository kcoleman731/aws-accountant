variable "phone_number" {
  description = "Phone number to send alerts to.s"
  type        = string
}

variable "email" {
  description = "Email to send alerts to."
  type        = string
}

variable "charge_alarms" {
  description = "Confiruation for EstimatedCharges alarms to monitor charges."
  type = list(object({
    name      = string
    threshold = string
  }))
}

variable "egress_threshold" {
  description = "Confiruation for NetworkOut alarms to monitor EC2 egress."
  type        = number
}
