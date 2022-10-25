// VPC Endpoints
module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.11.0"

  vpc_id             = aws_vpc.dataplane_vpc.id
  security_group_ids = [aws_security_group.sg.id]

  endpoints = {
    s3 = {
      count = length(local.private_subnets_cidr)
      service      = "s3"
      service_type = "Gateway"
      route_table_ids = flatten([
        aws_route_table.private_rt[*].id
      ])
      tags = {
        Name = "${local.prefix}-s3-vpc-endpoint"
      }
    },
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = aws_subnet.private[*].id
      tags = {
        Name = "${local.prefix}-sts-vpc-endpoint"
      }
    },
    kinesis-streams = {
      service             = "kinesis-streams"
      private_dns_enabled = true
      subnet_ids          = aws_subnet.private[*].id
      tags = {
        Name = "${local.prefix}-kinesis-vpc-endpoint"
      }
    }
  }
}

resource "aws_security_group" "privatelink" {
  vpc_id      = aws_vpc.dataplane_vpc.id

  ingress {
    description = "Inbound rules"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.sg.id]
  }

  ingress {
    description = "Inbound rules"
    from_port   = 6666
    to_port     = 6666
    protocol    = "tcp"
    security_groups = [aws_security_group.sg.id]
  }

  egress {
    description = "Outbound rules"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.sg.id]
  }

  egress {
    description = "Outbound rules"
    from_port   = 6666
    to_port     = 6666
    protocol    = "tcp"
    security_groups = [aws_security_group.sg.id]
  }

  tags = {
    Name = "${local.prefix}-privatelink-sg"
  }
}

resource "aws_vpc_endpoint" "backend_rest" {
  vpc_id             = aws_vpc.dataplane_vpc.id
  service_name       = var.workspace_vpce_service
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.privatelink.id]
  subnet_ids         =  aws_subnet.privatelink[*].id
  private_dns_enabled = true
  depends_on = [aws_subnet.privatelink]
  tags = {
    Name = "${local.prefix}-databricks-backend-rest"
  }
}

resource "aws_vpc_endpoint" "backend_relay" {
  vpc_id             = aws_vpc.dataplane_vpc.id
  service_name       = var.relay_vpce_service
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.privatelink.id]
  subnet_ids         = aws_subnet.privatelink[*].id
  private_dns_enabled = true
  depends_on = [aws_subnet.privatelink]
  tags = {
    Name = "${local.prefix}-databricks-backend-relay"
  }
}