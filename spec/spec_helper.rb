ENV['APP_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require_relative '../server'
require 'rack/test'
require 'rspec'
require 'debug'
require 'pg'

DB_CONFIG = {
  dbname: 'postgres-test',
  user: 'postgres-test',
  password: '654321',
  port: '5432',
  host: 'postgres-test'
}.freeze

RSpec.configure do |config|
  include Rack::Test::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.example_status_persistence_file_path = './spec/support/failures.txt'

  # Configurações para testes usando o banco de dados de teste
  config.before(:each) do
    @conn = PG.connect(DB_CONFIG)
    @conn.exec('BEGIN')
  end

  config.after(:each) do
    @conn.exec('ROLLBACK') unless @conn.transaction_status == 0
    @conn.close
  end
end
