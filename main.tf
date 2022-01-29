terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  experiments = [module_variable_optional_attrs]
}

provider "aws" {
  region = "us-east-1"
}

//-----------------------------------------------------------------------------
// Estimated Charges SNS Topic & Subcription
//-----------------------------------------------------------------------------

resource "aws_sns_topic" "estimated_charges_alarm_topic" {
  name = "estimated-charges-alarm-topic"
}

resource "aws_sns_topic_subscription" "estimated_charges_alarm_email_subscription" {
  topic_arn = aws_sns_topic.estimated_charges_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.email
}

resource "aws_sns_topic_subscription" "estimated_charges_alarm_sns_subscription" {
  topic_arn = aws_sns_topic.estimated_charges_alarm_topic.arn
  protocol  = "sms"
  endpoint  = var.phone_number
}

//-----------------------------------------------------------------------------
// Estimated Charges Alarm
//-----------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "estimated_charges_alarm" {
  for_each            = { for alarm in var.charge_alarms : alarm.name => alarm }
  alarm_name          = each.key
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600"
  statistic           = "Maximum"
  threshold           = each.value.threshold
  alarm_description   = "CloudWatch Billing Alarm which triggers when your AWS bill goes above ${each.value.threshold} dollars."
  alarm_actions       = [aws_sns_topic.estimated_charges_alarm_topic.arn]
  dimensions = {
    Currency = "USD"
  }
}

//-----------------------------------------------------------------------------
// Network Egress SNS Topic & Subcription
//-----------------------------------------------------------------------------

resource "aws_sns_topic" "network_egress_alarm_topic" {
  name = "estimated-charges-alarm-topic"
}

resource "aws_sns_topic_subscription" "network_egress_alarm_email_subscription" {
  topic_arn = aws_sns_topic.network_egress_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.email
}

resource "aws_sns_topic_subscription" "network_egress_alarm_sns_subscription" {
  topic_arn = aws_sns_topic.network_egress_alarm_topic.arn
  protocol  = "sms"
  endpoint  = var.phone_number
}

//-----------------------------------------------------------------------------
// Network Egress Alarm
//-----------------------------------------------------------------------------

data "aws_instances" "running_instances" {
  instance_tags = {
    EgressMonitored = "True"
  }
}

resource "aws_cloudwatch_metric_alarm" "asg_network_egress_alarm" {
  for_each            = { for instance in data.aws_instances.running_instances : instance.arn => instance }
  alarm_name          = "${each.value.arn}-egress-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Maximum"
  threshold           = var.egress_threshold
  alarm_description   = "CloudWatch EC2 Alarm which triggers when Egress goes above ${var.egress_threshold} GB for ${each.value.id}."
  alarm_actions       = [aws_sns_topic.network_egress_alarm_topic.arn]
  dimensions = {
    InstanceId = each.value.id
  }
}
