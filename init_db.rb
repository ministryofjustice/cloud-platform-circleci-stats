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
  SQL
  puts sql
rescue PG::Error => e
  puts e.message
ensure
  conn.close if conn
end
