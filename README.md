# AWS Accountant 

`aws-accountant` is a dead simple Terraform module which helps you monitor your cloud spend. `cloud-accountant` can provision CloudWatch alarms to notify you when:

1. Egress for your EC2 instances goes above certain thresholds. 
2. Your total AWS bill goes above certain thresholds.

## Motivation

Suprise cloud bills are a reality for cloud engineers. AWS provides tools that allow you to configure billing alerts, but tehy are not enabled by default. `cloud-account` makes it dead simple to enable alerts. 

See blog post for more context. 

## Usage 

```hcl
module "aws-accountant" {
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

## Metric Coverage 

| Sevice        | Metric            | Description                                                                               |
|---------------|-------------------|-------------------------------------------------------------------------------------------|
| CloudWatch    | NetworkOut        | The number of bytes sent out by the instance on all network interfaces. I.E. egress data. |
| CloudWatch    | EstimatedCharges  | Estimated charges for your AWS account at any given point in time.

Want more? Shoot me feedback.

## How it works

For Egress cost alerts, `aws-accountant` provisions a CloudWatch alarm which monitors the [`NetworkOut`](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html) metric for your EC2 instances. You can specific specific instance ids, or have `aws-accountant` query your account for all instances and configure alerts for each. 

For total bill alerts, `aws-accountant` provisions CloudWatch alarms which monitor the [`EstimatedCharges`](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/monitor_estimated_charges_with_cloudwatch.html) metric for your account. You are able to specify multiple thresholds and get alerts each time one is reached.

## License 

Apache 2 Licensed. See LICENSE for full details.
