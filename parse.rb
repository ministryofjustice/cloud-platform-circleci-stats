#!/usr/bin/env ruby

require 'json'
require 'time'
require 'pry-byebug'
require 'pp'

class Job
  attr_reader :queued_at, :start_time, :build_time_millis

  def initialize(hash)
    @queued_at = to_time hash.fetch('usage_queued_at')
    @start_time = to_time hash.fetch('start_time')
    @build_time_millis = hash.fetch('build_time_millis').to_i
  end

  def time_in_queue
    start_time.to_i - queued_at.to_i
  end

  def duration
    build_time_millis / 1000
  end

  private

  def to_time(val)
    val.nil? ? nil : Time.parse(val)
  end
end

json = File.read('30.json')

jobs = JSON.parse(json)

jobs.each do |hash|
  job = Job.new(hash)
  puts [
    job.queued_at.strftime("%Y-%m-%d %H:%M:%S"),
    job.time_in_queue,
    job.duration
  ].join(', ')
end

__END__

[ {
  "committer_date" : "2019-06-20T15:04:46+01:00",
  "body" : "",
  "usage_queued_at" : "2019-06-20T14:05:11.235Z",
  "reponame" : "cla_backend",
  "build_url" : "https://circleci.com/gh/ministryofjustice/cla_backend/1383",
  "parallel" : 1,
  "branch" : "feature/LGA-644_multiple-research-preferences-options",
  "username" : "ministryofjustice",
  "author_date" : "2019-06-20T15:04:46+01:00",
  "why" : "github",
  "user" : {
    "is_user" : true,
    "login" : "said-moj",
    "avatar_url" : "https://avatars1.githubusercontent.com/u/45761276?v=4",
    "name" : null,
    "vcs_type" : "github",
    "id" : 45761276
  },
  "vcs_revision" : "c07d37a2174863fa7de33bd1386e2dab02c3d208",
  "workflows" : {
    "job_name" : "test",
    "job_id" : "da6884a5-0c39-49d4-af6c-8fe16ffc4135",
    "workflow_id" : "1058aa35-43f5-48eb-aabc-baa34befaeca",
    "workspace_id" : "1058aa35-43f5-48eb-aabc-baa34befaeca",
    "upstream_job_ids" : [ ],
    "upstream_concurrency_map" : { },
    "workflow_name" : "build_and_test"
  },
  "vcs_tag" : null,
  "pull_requests" : [ {
    "head_sha" : "c07d37a2174863fa7de33bd1386e2dab02c3d208",
    "url" : "https://github.com/ministryofjustice/cla_backend/pull/576"
  } ],
  "build_num" : 1383,
  "committer_email" : "45761276+said-moj@users.noreply.github.com",
  "status" : "success",
  "committer_name" : "said-moj",
  "subject" : "Removed references to old field contact_for_research_via but did not remove field from db",
  "dont_build" : null,
  "lifecycle" : "finished",
  "fleet" : "picard",
  "stop_time" : "2019-06-20T14:07:44.234Z",
  "build_time_millis" : 150508,
  "start_time" : "2019-06-20T14:05:13.726Z",
  "platform" : "2.0",
  "outcome" : "success",
  "vcs_url" : "https://github.com/ministryofjustice/cla_backend",
  "author_name" : "said-moj",
  "queued_at" : "2019-06-20T14:05:11.269Z",
  "author_email" : "said.shire@digital.justice.gov.uk"
}, {
