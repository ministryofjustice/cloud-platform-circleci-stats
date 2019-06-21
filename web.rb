#!/usr/bin/env ruby

require 'bundler/setup'
require 'sinatra'
require './lib/db'

class Build
  attr_reader :number, :queued_at, :start_time, :duration, :vcs_url, :committer_email

  def initialize(args)
    @number = args.fetch('number')
    @queued_at = args.fetch('queued_at')
    @start_time = args.fetch('start_time')
    @duration = args.fetch('duration')
    @vcs_url = args.fetch('vcs_url')
    @committer_email = args.fetch('committer_email')
  end
end

def get_builds
  @builds = []
  begin
    conn = Db::connection
    rs = conn.exec "SELECT * FROM builds"
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
      <th>Number</th>
    </tr>
  </thead>
  <tbody>
    <% @builds.each do |build| %>
      <tr>
        <td><%= build.number %></td>
      </tr>
    <% end %>
  </tbody>
</table>
