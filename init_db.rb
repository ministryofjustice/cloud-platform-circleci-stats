#!/usr/bin/env ruby

require 'bundler/setup'
require './lib/db'


sql = <<~SQL
  DROP TABLE IF EXISTS builds;
  CREATE TABLE builds(
    number INTEGER PRIMARY KEY,
    queued_at INTEGER,
    start_time INTEGER,
    duration INTEGER,
    vcs_url VARCHAR(255),
    committer_email VARCHAR(255)
  )
SQL

begin
  conn = Db::connection
  conn.exec sql
rescue PG::Error => e
  puts e.message
ensure
  conn.close if conn
end
