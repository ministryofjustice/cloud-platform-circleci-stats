#!/usr/bin/env ruby

# Fetch data on the last 30 builds from circleci.com

require 'bundler/setup'
require 'open-uri'
require 'json'
require 'time'
require './lib/db'

# NB: changing 'limit' from 30 to 100 (the max. the API will accept) seems to return a different
# set of 100 build jobs. In particular, you definitely do not get the most recent 100 jobs,
# whereas with a limit of 30, you do seem to get jobs in reverse chronological order.
API_URL = 'https://circleci.com/api/v1.1/organization/github/ministryofjustice?shallow=true&offset=0&limit=30&mine=false'

class Job
  attr_reader :number, :queued_at, :start_time, :build_time_millis, :vcs_url, :committer_email

  def initialize(hash)
    @number = hash.fetch('build_num')
    @queued_at = to_integer hash.fetch('usage_queued_at')
    @start_time = to_integer hash.fetch('start_time')
    @build_time_millis = hash.fetch('build_time_millis').to_i
    @vcs_url = hash.fetch('vcs_url')
    @committer_email = hash.fetch('committer_email')
  end

  def time_in_queue
    start_time - queued_at
  end

  def duration
    build_time_millis / 1000
  end

  private

  def to_integer(val)
    val.nil? ? nil : Time.parse(val).to_i
  end
end

def sql_int(value)
  value.nil? ? 'null' : value
end

def short_vcs_url(url)
  url.sub('https://github.com/ministryofjustice/', '')
end

def insert_build(conn, job)
  sql = <<~SQL
  INSERT INTO builds (
    number,
    queued_at,
    start_time,
    duration,
    vcs_url,
    committer_email
  ) VALUES (
    #{sql_int job.number},
    #{sql_int job.queued_at},
    #{sql_int job.start_time},
    #{sql_int job.duration},
    '#{short_vcs_url job.vcs_url}',
    '#{job.committer_email}'
  )
  SQL
  conn.exec sql
end

url = API_URL + '&circle-token=' + ENV.fetch('API_TOKEN')
json = open(url).read
jobs = JSON.parse(json)

begin
  conn = Db::connection

  jobs.each do |hash|
    job = Job.new(hash)
    begin
      insert_build(conn, job)
    rescue PG::UniqueViolation
      # We expect to get some jobs we saw previously, so
      # we just ignore these errors
    end
  end
rescue PG::Error => e
  puts e.message
ensure
  conn.close if conn
end
