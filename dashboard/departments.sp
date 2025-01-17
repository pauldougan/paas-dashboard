
card "departments_count" {
  type = "info"
  icon = "hashtag"
  label = "departments count"
  sql = query.departments_count.sql
  width = "2"
  href = "${dashboard.departments_report.url_path}"
}

table "departments" {
  width = 12
  sql = query.departments.sql
}

dashboard "departments_report" {
  title = "GOV.UK PaaS departments report"
  table {
    base = table.departments
  }
  tags = {
  service = "departments"
  type     = "report"
  }
}

dashboard "departments" {
  title = "GOV.UK PaaS departments dashboard"

  input {
    base = input.departments
  }
  card {
    base = card.departments_count
  }
  table {
    base = table.departments
  }
  tags = {
  service = "departments"
  type     = "dashboard"
  }
}