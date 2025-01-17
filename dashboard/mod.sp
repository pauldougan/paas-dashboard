mod "paas-dashboard" {
  title = "GOV.UK PaaS dashboard"
  description = "a dashboard of GOV.UK PaaS platform metrics"
  categories = ["cf", "govuk-paas"]
  require {
    steampipe = "0.15.3"
    plugin "csv" {
      version = "0.3.2"
    }
    plugin "github" {
      version = "0.18.0"
    }
    plugin "rss" {
      version = "0.2.1"
    }
    plugin "config" {
      version = "0.1.0"
    } 
    plugin "net" {
      version = "0.6.0" 
    }
    plugin "whois" {
      version = "0.5.0"
    }
    plugin "prometheus" {
      version = "0.1.0"
    }
    plugin "terraform" {
      version = "0.1.0"
    }
    plugin "zendesk" {
      version = "0.4.1"
    }
  }
}