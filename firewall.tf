resource "aws_networkfirewall_rule_group" "databricks_fqdn_allowlist" {
  capacity = 100
  name     = "${local.prefix}-${var.region}-databricks-fqdn-allowlist"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        targets              = concat([var.metastore_url], local.firewall_allow_list)
      }
    }
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = [var.vpc_cidr_range]
        }
      }
    }
  }
    tags = {
        Name = "${local.prefix}-${var.region}-databricks-fqdn-allowlist"
  }
}

resource "aws_networkfirewall_rule_group" "databricks_protocol_denylist" {
  capacity    = 100
  name        = "${local.prefix}-databricks-protocol-denylist"
  type        = "STATEFUL"
  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = [var.vpc_cidr_range]
        }
      }
    }
    rules_source {
      dynamic "stateful_rule" {
        for_each = local.firewall_protocol_deny_list
        content {
          action = "DROP"
          header {
            destination      = "ANY"
            destination_port = "ANY"
            protocol         = stateful_rule.value
            direction        = "ANY"
            source_port      = "ANY"
            source           = "ANY"
          }
        rule_option {
            keyword = "sid:${stateful_rule.key + 1}"
          }
        }
    }
    }
  }
    tags = {
        Name = "${local.prefix}-databricks-protocol-denylist"
  }
}

resource "aws_networkfirewall_firewall_policy" "databricks_nfw_policy" {
  name = "${local.prefix}-databricks-nfw-policy"
  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.databricks_fqdn_allowlist.arn
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.databricks_protocol_denylist.arn
    }   
  }
  tags = {
    Name = "${local.prefix}-${var.region}-databricks-nfw-policy"
  }
}

resource "aws_networkfirewall_firewall" "nfw" {
  name                = "${local.prefix}-nfw"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.databricks_nfw_policy.arn
  vpc_id              = aws_vpc.dataplane_vpc.id
  dynamic "subnet_mapping" {
    for_each = aws_subnet.firewall[*].id
    content {
      subnet_id = subnet_mapping.value
    }
  }
  tags = {
    Name = "${local.prefix}-${var.region}-databricks-nfw"
  }
}