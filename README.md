# Cloud Accountant 

`cloud-accountant` is a dead simple Terraform module which helps you monitor your cloud spend. `cloud-accountant` can provision CloudWatch alarms to notify you when. 

1. Your total AWS bill goes above certain thresholds
2. Egress for your EC2 instances goes above certain thresholds. 

## Usage 

```hcl
module "cloud-accountant" {
    source = "github.com/kcoleman731/cloud-accountant"

    # Where alerts should go.
    email = "cloud@accountant.com"
    phone_number = "+4445556666"

    # Billing Threshold Config
    charge_alarms = [
        {
            name = "Ten"
            threshold = "10"
        },
        {
            name = "Twenty"
            threshold = "20"
        }
    ]

    # Egress Threshold Config
    egress_threshold = 300
}
```

## How it works

## License 

Apache 2 Licensed. See LICENSE for full details.
