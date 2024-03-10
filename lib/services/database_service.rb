DB_CONFIG = {
  dbname: 'postgres',
  user: 'postgres',
  password: 'postgres',
  port: '5432',
  host: 'postgres'
}.freeze

TEST_DB_CONFIG = {
  dbname: 'postgres-test',
  user: 'postgres-test',
  password: '654321',
  port: '5432',
  host: 'postgres-test'
}.freeze

require 'pg'
require 'json'

class DatabaseService
  def self.connect
    config = ENV['APP_ENV'] == 'test' ? TEST_DB_CONFIG : DB_CONFIG
    PG.connect(config)
  end
end
