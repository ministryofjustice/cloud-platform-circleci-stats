#!/usr/bin/env ruby

require 'bundler/setup'
require 'pg'

begin
  conn = PG.connect(
    host:      'localhost',
    dbname:    'circle_stats',
    user:      'stats',
    password:  'password123',
  )
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
  conn.exec sql
rescue PG::Error => e
  puts e.message
ensure
  conn.close if conn
end
