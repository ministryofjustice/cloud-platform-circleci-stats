#!/usr/bin/env ruby

require 'bundler/setup'
require 'sinatra'
require 'date'
require './lib/db'

class Build
  attr_reader :number, :queued_at, :start_time, :duration, :vcs_url, :committer_email

  def initialize(args)
    @number = args.fetch('number').to_i
    @queued_at = args.fetch('queued_at').to_i
    @start_time = args.fetch('start_time').to_i
    @duration = args.fetch('duration').to_i
    @vcs_url = args.fetch('vcs_url')
    @committer_email = args.fetch('committer_email')
  end

  def started
    formatted_time start_time
  end

  def queued
    formatted_time queued_at
  end

  def wait_time
    start_time == 0 ? nil : start_time - queued_at
  end

  private

  def formatted_time(t)
    t == 0 ? '' : epoch_to_formatted(t)
  end

  def epoch_to_formatted(epoch)
    epoch_to_datetime(epoch).strftime("%Y-%m-%d %H:%M:%S")
  end

  def epoch_to_datetime(epoch)
    Time.at(epoch).to_datetime
  end
end

def get_builds
  @builds = []
  begin
    conn = Db::connection
    rs = conn.exec "SELECT * FROM builds ORDER BY queued_at DESC"
    rs.each do |row|
      @builds << Build.new(row)
    end
  rescue PG::Error => e
    puts e.message
  ensure
    conn.close if conn
  end
end

get '/' do
  get_builds
  erb :index
end

__END__

@@ layout
<html><body>
<%= yield %>
</html></body>

@@ index
<table>
  <thead>
    <tr>
      <th>ID</th>
      <th>Queued</th>
      <th>Wait time</th>
      <th>Duration</th>
    </tr>
  </thead>
  <tbody>
    <% @builds.each do |build| %>
      <tr>
        <td><%= build.number %></td>
        <td><%= build.queued %></td>
        <td><%= build.wait_time %></td>
        <td><%= build.duration %></td>
      </tr>
    <% end %>
  </tbody>
</table>
