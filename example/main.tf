module "aws-accountant" {
  source = "../"

  email        = "cloud@accountant.com"
  phone_number = "+4445556666"
  # egress_threshold = 300 // Ensure instances are tagged with `MonitorEgress:true`.
  charge_thresholds = [
    {
      name      = "Ten"
      threshold = "10"
    },
    {
      name      = "Twenty"
      threshold = "20"
    }
  ]
}
