# Autospotting configuration
variable "autospotting_allowed_instance_types" {
  description = <<EOF
Comma separated list of allowed instance types for spot requests,
in case you want to exclude specific types (also support globs).

Example: 't2.*,m4.large'

Using the 'current' magic value will only allow the same type as the
on-demand instances set in the group's launch configuration.
EOF
  default = ""
}

variable "autospotting_disallowed_instance_types" {
  description = <<EOF
Comma separated list of disallowed instance types for spot requests,
in case you want to exclude specific types (also support globs).

Example: 't2.*,m4.large'
EOF
  default = ""
}

variable "autospotting_instance_termination_method" {
  description = <<EOF
Instance termination method. Must be one of 'autoscaling' (default) or
'detach' (compatibility mode, not recommended).
EOF
  default = "autoscaling"
}

variable "autospotting_min_on_demand_number" {
  description = "Minimum on-demand instances to keep in absolute value"
  default     = "0"
}

variable "autospotting_min_on_demand_percentage" {
  description = "Minimum on-demand instances to keep in percentage"
  default     = "0.0"
}

variable "autospotting_on_demand_price_multiplier" {
  description = "Multiplier for the on-demand price"
  default     = "1.0"
}

variable "autospotting_spot_product_description" {
  description = <<EOF
The Spot Product or operating system to use when looking
up spot price history in the market.

Valid choices
- Linux/UNIX | SUSE Linux | Windows
- Linux/UNIX (Amazon VPC) | SUSE Linux (Amazon VPC) | Windows (Amazon VPC)
EOF
  default = "Linux/UNIX (Amazon VPC)"
}

variable "autospotting_spot_price_buffer_percentage" {
  description = "Percentage above the current spot price to place the bid"
  default     = "10.0"
}

variable "autospotting_bidding_policy" {
  description = "Bidding policy for the spot bid"
  default     = "normal"
}

variable "autospotting_regions_enabled" {
  description = "Regions in which autospotting is enabled"
  default     = ""
}

variable "autospotting_tag_filters" {
  description = <<EOF
Tags to filter which ASGs autospotting considers. If blank
by default this will search for asgs with spot-enabled=true (when in opt-in
mode) and will skip those tagged with spot-enabled=false when in opt-out
mode.

You can set this to many tags, for example:
spot-enabled=true,Environment=dev,Team=vision
EOF
  default = ""
}

variable "autospotting_tag_filtering_mode" {
  description = <<EOF
Controls the tag-based ASG filter. Supported values: 'opt-in' or 'opt-out'.
Defaults to opt-in mode, in which it only acts against the tagged groups. In
opt-out mode it works against all groups except for the tagged ones.
EOF
  default = "opt-in"
}

# Lambda configuration
locals {
  # If a lambda_zipname variable is set other than the default use that, if the
  lambda_zipname_effective_value = var.lambda_zipname == "package/autospotting.zip" ? "${path.module}/modules/lambda/${var.lambda_zipname}" : var.lambda_zipname
}

variable "lambda_zipname" {
  description = "Name of the archive, relative to the module"
  default     = "package/autospotting.zip"
}

variable "lambda_s3_bucket" {
  description = "Bucket which the archive is stored in"
  default     = ""
}

variable "lambda_s3_key" {
  description = "Key in S3 under which the archive is stored"
  default     = ""
}

variable "lambda_runtime" {
  description = "Environment the lambda function runs in"
  default     = "go1.x"
}

variable "lambda_memory_size" {
  description = "Memory size allocated to the lambda run"
  default     = 1024
}

variable "lambda_timeout" {
  description = "Timeout after which the lambda timeout"
  default     = 300
}

variable "lambda_run_frequency" {
  description = "How frequent should lambda run"
  default     = "rate(5 minutes)"
}

variable "lambda_tags" {
  description = "Tags to be applied to the Lambda function"
  default     = {
    # You can add more values below
    Name = "autospotting"
  }
}

# Label configuration
variable "label_context" {
  description = "Used to pass in label module context"
  type        = object({
    namespace           = string
    environment         = string
    stage               = string
    name                = string
    enabled             = bool
    delimiter           = string
    attributes          = list(string)
    label_order         = list(string)
    tags                = map(string)
    additional_tag_map  = map(string)
    regex_replace_chars = string
  })
  default     = {
    namespace           = ""
    environment         = ""
    stage               = ""
    name                = ""
    enabled             = true
    delimiter           = ""
    attributes          = []
    label_order         = []
    tags                = {}
    additional_tag_map  = {}
    regex_replace_chars = ""
  }
}

variable "label_namespace" {
  description = "Namespace, which could be your organization name or abbreviation"
  default     = ""
}

variable "label_environment" {
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  default     = ""
}

variable "label_stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  default     = ""
}

variable "label_name" {
  description = "Solution name, e.g. 'autospotting' or 'autospotting-storage-optimized'"
  default     = "autospotting"
}

variable "label_attributes" {
  type        = list(string)
  description = "Additional attributes (e.g. 1)"
  default     = []
}

variable "label_tags" {
  description = "Additional tags (e.g. map('BusinessUnit','XYZ')"
  type        = map(string)
  default     = {}
}

variable "label_delimiter" {
  description = "Delimiter to be used between namespace, environment, stage, name and attributes"
  default     = "-"
}
