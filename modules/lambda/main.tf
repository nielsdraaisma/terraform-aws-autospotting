module "label" {
  source  = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.13.0"
  context = var.label_context
}

resource "aws_lambda_function" "autospotting" {
  count = var.lambda_s3_bucket == "" ? 1 : 0

  function_name    = module.label.id
  filename         = var.lambda_zipname
  source_code_hash = filebase64sha256(var.lambda_zipname)
  role             = var.lambda_role_arn
  runtime          = var.lambda_runtime
  timeout          = var.lambda_timeout
  handler          = "autospotting"
  memory_size      = var.lambda_memory_size
  tags             = merge(var.lambda_tags, module.label.tags)

  environment {
    variables = {
      ALLOWED_INSTANCE_TYPES       = var.autospotting_allowed_instance_types
      DISALLOWED_INSTANCE_TYPES    = var.autospotting_disallowed_instance_types
      INSTANCE_TERMINATION_METHOD  = var.autospotting_instance_termination_method
      MIN_ON_DEMAND_NUMBER         = var.autospotting_min_on_demand_number
      MIN_ON_DEMAND_PERCENTAGE     = var.autospotting_min_on_demand_percentage
      ON_DEMAND_PRICE_MULTIPLIER   = var.autospotting_on_demand_price_multiplier
      SPOT_PRICE_BUFFER_PERCENTAGE = var.autospotting_spot_price_buffer_percentage
      SPOT_PRODUCT_DESCRIPTION     = var.autospotting_spot_product_description
      BIDDING_POLICY               = var.autospotting_bidding_policy
      REGIONS                      = var.autospotting_regions_enabled
      TAG_FILTERS                  = var.autospotting_tag_filters
      TAG_FILTERING_MODE           = var.autospotting_tag_filtering_mode
    }
  }
}

resource "aws_lambda_function" "autospotting_from_s3" {
  count = var.lambda_s3_bucket == "" ? 0 : 1

  function_name = module.label.id
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = var.lambda_s3_key
  role          = var.lambda_role_arn
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout
  handler       = "autospotting"
  memory_size   = var.lambda_memory_size
  tags          = merge(var.lambda_tags, module.label.tags)

  environment {
    variables = {
      ALLOWED_INSTANCE_TYPES       = var.autospotting_allowed_instance_types
      DISALLOWED_INSTANCE_TYPES    = var.autospotting_disallowed_instance_types
      INSTANCE_TERMINATION_METHOD  = var.autospotting_instance_termination_method
      MIN_ON_DEMAND_NUMBER         = var.autospotting_min_on_demand_number
      MIN_ON_DEMAND_PERCENTAGE     = var.autospotting_min_on_demand_percentage
      ON_DEMAND_PRICE_MULTIPLIER   = var.autospotting_on_demand_price_multiplier
      SPOT_PRICE_BUFFER_PERCENTAGE = var.autospotting_spot_price_buffer_percentage
      SPOT_PRODUCT_DESCRIPTION     = var.autospotting_spot_product_description
      BIDDING_POLICY               = var.autospotting_bidding_policy
      REGIONS                      = var.autospotting_regions_enabled
      TAG_FILTERS                  = var.autospotting_tag_filters
      TAG_FILTERING_MODE           = var.autospotting_tag_filtering_mode
    }
  }
}

