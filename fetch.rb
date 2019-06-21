#!/usr/bin/env ruby

# Fetch data on the last 30 builds from circleci.com

require 'open-uri'

# NB: changing 'limit' from 30 to 100 (the max. the API will accept) seems to return a different
# set of 100 build jobs. In particular, you definitely do not get the most recent 100 jobs,
# whereas with a limit of 30, you do seem to get jobs in reverse chronological order.
API_URL = 'https://circleci.com/api/v1.1/organization/github/ministryofjustice?shallow=true&offset=0&limit=30&mine=false'

url = API_URL + '&circle-token=' + ENV.fetch('API_TOKEN')

content = open(url).read

puts content
