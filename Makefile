SHELL            := /usr/local/bin/bash

AWK          := gawk
CF           := cf
CSVCUT       := csvcut
CSVFORMAT    := csvformat 
CSVGREP      := csvgrep
CSVJSON      := csvjson
CSVSORT      := csvsort
CSVSQL       := csvsql
CSVSTACK     := csvstack
CSVTOTABLE   := csvtotable
HEADER       := ./bin/header
JQ           := jq
RM           := rm -rfv
SED          := gsed
STEAMPIPE    := steampipe
TEE          := tee
VISIDATA     := vd

PAAS_ENVDIR   := ~/.govuk-paas
DUBLIN_DOMAIN := cloud.service.gov.uk
LONDON_DOMAIN := london.cloud.service.gov.uk
CF1           := CF_HOME=$(PAAS_ENVDIR)/dublin $(CF)
CF2           := CF_HOME=$(PAAS_ENVDIR)/london $(CF)
LOGIN1        := https://login.$(DUBLIN_DOMAIN)/passcode
LOGIN2        := https://login.$(LONDON_DOMAIN)/passcode

all: extract-cf-data dashboard

clean:
	@echo clean platform data
	$(RM) orgs*.csv

dashboard:
	@echo show dashboard

data:
	$(VISIDATA) .

extract-cf-data: orgs.csv

login:
	open $(LOGIN1)
	$(CF1) api https://api.cloud.service.gov.uk
	$(CF1) login --sso 
	open $(LOGIN2)
	$(CF2) api https://api.london.cloud.service.gov.uk
	$(CF2) login --sso 
		
logout:
	$(CF1) logout
	$(CF2) logout

orgs.csv: orgs-dublin.csv orgs-london.csv
	$(CSVSTACK) orgs-dublin.csv orgs-london.csv |\
		$(AWK) -F, -e '$$1 == ""  {print "UNDEFINED" $$0}; $$1 != "" {print $$0}' |\
    	$(CSVSORT) -c1,2 |\
      	$(CSVFORMAT) -U 1 > $@
		
orgs-dublin.csv:
	$(CF1) curl '/v3/organizations?per_page=1000' |\
	  $(JQ) --arg region dublin -r '.resources[] | [.metadata.annotations.owner, $$region, .name, .guid, .created_at, .suspended] | @csv' |\
	  $(HEADER) -a "owner,region,org,guid,created,suspended" |\
	  $(CSVSORT) -c1,3 |\
	  $(SED) -E '/,CAT/d;/,BACC/d;/,ACC/d;/,SMOKE/d;/,ASATS/d' |\
	  $(TEE) $@

orgs-london.csv:
	$(CF2) curl '/v3/organizations?per_page=1000' |\
	  $(JQ) --arg region london -r '.resources[] | [.metadata.annotations.owner, $$region, .name, .guid, .created_at, .suspended] | @csv' |\
	  $(HEADER) -a "owner,region,org,guid,created,suspended" |\
	  $(CSVSORT) -c1,3 |\
	  $(SED) -E '/,CAT/d;/,BACC/d;/,ACC/d;/,SMOKE/d;/,ASATS/d' |\
	  $(TEE) $@

start:
	$(STEAMPIPE service start)
