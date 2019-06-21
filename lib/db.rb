require 'pg'

module Db
  def self.connection
    begin
      PG.connect(
        host:      'localhost',
        dbname:    'circle_stats',
        user:      'stats',
        password:  'password123',
      )
    rescue PG::Error => e
      puts e.message
    end
  end
end
