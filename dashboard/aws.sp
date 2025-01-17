
card "application_load_balancers_count" {
  type = "info"
  icon = "hashtag"
  label = "application load balancers count"
  sql = query.application_load_balancers_count.sql
  width = "2"
 }

card "cloudfront_distributions_count" {
  type = "info"
  icon = "hashtag"
  label = "cloudfront distributions count"
  sql = query.cloudfront_distributions_count.sql
  width = "2"
 }

card "ec2_instances_count" {
  type = "info"
  icon = "hashtag"
  label = "ec2 instances count"
  sql = query.ec2_instances_count.sql
  width = "2"
 }

card "rds_db_instances_count" {
  type = "info"
  icon = "hashtag"
  label = "rds database count"
  sql = query.rds_db_instances_count.sql
  width = "2"
  href = "${dashboard.rds_db_instances_report.url_path}" 

 }

 card "s3_buckets_count" {
  type = "info"
  icon = "hashtag"
  label = "s3 buckets count"
  sql = query.s3_buckets_count.sql
  width = "2"
 }

 card "sqs_queues_count" {
  type = "info"
  icon = "hashtag"
  label = "sqs queues count"
  sql = query.sqs_queues_count.sql
  width = "2"
 }

 card "elasticache_clusters_count" {
  type = "info"
  icon = "hashtag"
  label = "elasticache clusters count"
  sql = query.elasticache_clusters_count.sql
  width = "2"
 }

 table "rds_db_instances" {
  width = 12
  sql = query.rds_db_instances_report.sql
 }
 
 card "vpcs_count" {
  type = "info"
  icon = "hashtag"
  label = "vpcs count"
  sql = query.vpcs_count.sql
  width = "2"
 }

card "vpc_subnets_count" {
  type = "info"
  icon = "hashtag"
  label = "vpc subnets count"
  sql = query.vpc_subnets_count.sql
  width = "2"
 }

card "vpc_internet_gateways_count" {
  type = "info"
  icon = "hashtag"
  label = "vpc internet gateways count"
  sql = query.vpc_internet_gateways_count.sql
  width = "2"
 }

dashboard "rds_db_instances_report" {
  title = "GOV.UK PaaS RDS dashboard"
  table {
    base = table.rds_db_instances
  }
  tags = {
    service = "aws"
    type     = "report"
  }
}

dashboard "aws" {
  title = "GOV.UK PaaS AWS dashboard"
  card {
    base = card.vpcs_count
  }
  card {
    base = card.vpc_subnets_count
  }
  card {
    base = card.vpc_internet_gateways_count
  }
  card {
    base = card.application_load_balancers_count
  }
  card {
    base = card.ec2_instances_count
  }
  card {
    base = card.cloudfront_distributions_count
  }
  card {
    base = card.rds_db_instances_count
  }
  card {
    base = card.s3_buckets_count
  }
  card {
    base = card.sqs_queues_count
  }
  card {
    base = card.elasticache_clusters_count
  }
  tags = {
    service = "aws"
    type     = "dashboard"
  }
}
