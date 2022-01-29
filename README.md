# 👨‍💼🧮 AWS Accountant 

`aws-accountant` is a dead simple Terraform module which helps you monitor your cloud spend. `cloud-accountant` can provision CloudWatch alarms to notify you when:

1. Your total AWS bill goes above certain thresholds.
2. Egress for your EC2 instances goes above certain thresholds. 

### 💪 Motivation
---

Suprise cloud bills are a reality for cloud engineers. AWS provides tools that allow you to configure billing alerts, but they are not enabled by default. `cloud-account` makes it dead simple to enable alerts. 

See blog post for more context. 

### ✅ Prerequisites 
---

Before provision CloudWatch alarms, you must enable billing alerts via the AWS console. As far as I can tell, there is no way to do this programatically (CloudWatch team, looking at you 👀). Instructions for doing so can [be found here](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/monitor_estimated_charges_with_cloudwatch.html#turning_on_billing_metrics).

### 🎉 Usage 
---

```hcl
module "aws-accountant" {
    source = "git@github.com:kcoleman731/aws-accountant.git"

    # Where alerts should go.
    email = "cloud@accountant.com"
    phone_number = "+4445556666"

    # Charge threshold config.
    charge_thresholds = [
        {
            name = "Ten"
            threshold = "10"
        },
        {
            name = "Twenty"
            threshold = "20"
        }
    ]

    # Egress threshold config.
    egress_threshold = 300
}
```

### 📈 Metric Coverage 
---

| Sevice        | Metric            | Description                                                                               |
|---------------|-------------------|-------------------------------------------------------------------------------------------|
| CloudWatch    | EstimatedCharges  | Estimated charges for your AWS account at any given point in time.
| CloudWatch    | NetworkOut        | The number of bytes sent out by the instance on all network interfaces. I.E. egress data. |

Want more? Shoot me feedback.

### 💼 How it works
---

For billing alerts, `aws-accountant` provisions CloudWatch alarms which monitor the [`EstimatedCharges`](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/monitor_estimated_charges_with_cloudwatch.html) metric for your account. You are able to specify multiple thresholds and get alerts each time one is reached.

For egress alerts, `aws-accountant` provisions a CloudWatch alarm which monitors the [`NetworkOut`](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html) metric for your EC2 instances. You can specific specific instance ids, or have `aws-accountant` query your account for all instances and configure alerts for each. 

In order to recieve alerts, `cloud-accountant` will provision an SNS topic for both types of alarm. It will then subscribe your phone number (to recieve SMS) and you email address (to recieve emails) to the SNS topic. 

## 📋 License 
--- 

Apache 2 Licensed. See [LICENSE](./LICENSE) for full details.
