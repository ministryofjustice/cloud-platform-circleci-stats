#!/usr/bin/env ruby

# Fetch data on the last 30 builds from circleci.com

require 'bundler/setup'
require 'open-uri'
require 'json'
require 'time'
require 'elasticsearch'
require 'pry-byebug'

# NB: changing 'limit' from 30 to 100 (the max. the API will accept) seems to return a different
# set of 100 build jobs. In particular, you definitely do not get the most recent 100 jobs,
# whereas with a limit of 30, you do seem to get jobs in reverse chronological order.
CIRCLE_API_URL = 'https://circleci.com/api/v1.1/organization/github/ministryofjustice?shallow=true&offset=0&limit=30&mine=false'

ORG = 'ministryofjustice'

class Job
  attr_reader :id, :queued_at, :start_time, :build_time_millis, :vcs_url

  def initialize(hash)
    @vcs_url = hash.fetch('vcs_url')
    @id = build_id(hash)
    @queued_at = to_time hash.fetch('queued_at', nil)
    @start_time = to_time hash.fetch('start_time')
    @build_time_millis = hash.fetch('build_time_millis').to_i
  end

  def to_hash
    {
      queued_at: queued_at,
      start_time: start_time,
      duration: duration,
      time_in_queue: time_in_queue,
      project: short_vcs_url
    }
  end

  private

  def time_in_queue
    start_time.nil? ? nil : start_time - queued_at
  end

  def duration
    build_time_millis / 1000
  end

  def build_id(hash)
    number = hash.fetch('build_num')
    project = short_vcs_url
    [project, number].join(':')
  end

  def to_time(val)
    val.nil? ? nil : Time.parse(val)
  end

  def short_vcs_url
    vcs_url.sub("https://github.com/#{ORG}/", '')
  end
end

############################################################

es_client = Elasticsearch::Client.new(hosts: [ENV.fetch('ES_CLUSTER')], log: false)
circle_url = CIRCLE_API_URL + '&circle-token=' + ENV.fetch('API_TOKEN')
index = "circleci-#{Time.now.strftime("%Y%m%d")}"

jobs = JSON.parse(open(circle_url).read)

jobs.each do |hash|
  job = Job.new(hash)

  es_client.index(
    index: index,
    id: job.id,
    body: job.to_hash
  )
end
