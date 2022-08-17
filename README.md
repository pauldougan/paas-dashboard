
# GOV.UK PaaS dashboard

a [:fire: firebreak](https://insidegovuk.blog.gov.uk/2018/05/03/firebreaks-on-gov-uk/) experiment using [Steampipe](https://steampipe.io/) to make a dashboard to monitor the [GOV.UK PaaS](https://cloud.service.gov.uk) platform.

Initially it runs locally but it will be deployed to the cloud at some point for the team to access. 

see [kanban](https://github.com/pauldougan/paas-steampipe-dashboard/projects/1) 

# Overview

![screenshot of the dashboard](docs/screenshot.png)

[Steampipe](https://steampipe.io) provides a SQL layer on top of a [wide range of cloud platform services](https://hub.steampipe.io/plugins) that have apis using a postgresql [foreign data wrapper](https://github.com/turbot/steampipe-postgres-fdw). 

This dashboard uses [steampipe.io](https://steampipe.io) to build a set of dashboards over [GOV.UK PaaS](https://cloud.service.gov.uk).

It uses the [Cloud Foundry CLI](https://github.com/cloudfoundry/cli) to access the Cloud Foundry API and list resources, 
the data is saved locally as csv files and accessed from a local steampipe dashboard running at http://localhost:9194

It uses the plugins configured in [dashboards/mod.sp](dashboards/mod.sp)

The [dashboards](/dashboards) pull data from the underlying csv files using SQL and render the results as a dashboard.

# How it works

## 1. logs into Cloud Foundry using the CF CLI 

`cf login --sso`

## 2. extracts data as csv format from the CF API 


`cf curl /v3/foobar | in2csv -f json -k resources` converting JSON into CSV using csvkit's [in2csv](https://csvkit.readthedocs.io/en/latest/scripts/in2csv.html)

## 3. Logs into AWS using GDS CLI using MFA and assumes a role with read only permissions 

`gds aws paas-prod-ro`

## 4. extracts AWS data into CSV using steampipe query

`steampipe query query.sql -- output csv | gsed -E '/^$/d'`

Delete blank lines because steampipe adds a blank line to the end of the file.

## 5. launches steampipe dashboard

Render results locally accessing data from plugins, running SQL queries against the normalised data using postgresql

Read about the [data model](docs/datamodel.md)

# Prerequisites

Assumes you are on a mac with [homebrew](https://brew.sh) installed with `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

```
# homebrew packages
brew install cf-cli@8      # Cloud Foundry CLI
brew install gawk          # GNU awk
brew install gh            # GitHub CLI
brew install glow          # Glow CLI for markdown 
brew install gnu-sed       # GNU sed
brew install jq            # JSON wrangling tool
brew install steampipe     # make cloud apis queryble via SQL 
brew install yq            # YAML tools

# python tools
pip3 install csvkit        # csv wrangling tools
pip3 install visidata      # data wrangling swiss army penknife tool
```

a [GOV.UK PaaS account](https://cloud.service.gov.uk) with [global auditor](https://docs.cloudfoundry.org/concepts/roles.html#permissions) permissions.

# Usage

## 1. installation

git clone https://github.com/pauldougan/paas-steampipe-dashboard

`cd paas-steampipe-dashboard`

`make dependencies` to install all the necessary packages                       

## 2. configure plugins

see [config](config) for examples

`vim ~/.steampipe/config`

## 3. extract data

`make all` to login to Cloud Foundry, extract data and run dashboard

## 4. run dashboard 
  
`make dashboard` to run the dashboard with the current data and launch dashboard at http://localhost:9194

## 5. work with data

`make edit-csvs`



