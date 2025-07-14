resource "aws_cloudwatch_log_group" "flow_log" {
  count             = var.flow_log ? 1 : 0
  name              = var.flow_log_group_name
  retention_in_days = 7
}
resource "aws_iam_role" "flow_log_role" {
  count = var.flow_log ? 1 : 0
  name  = "${var.vpc_name}-flowlog-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy" "flow_log_policy" {
  count = var.flow_log ? 1 : 0
  name  = "${var.vpc_name}-flowlog-policy"
  role  = aws_iam_role.flow_log_role[0].name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}
resource "aws_flow_log" "vpc_flow_log" {
  count                = var.flow_log ? 1 : 0
  log_destination      = aws_cloudwatch_log_group.flow_log[0].arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.this.id
  iam_role_arn         = aws_iam_role.flow_log_role[0].arn
}




















