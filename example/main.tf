module "aws-accountant" {
  source = "github.com/kcoleman731/cloud-accountant"

  email            = "cloud@accountant.com"
  phone_number     = "+4445556666"
  egress_threshold = 300
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
