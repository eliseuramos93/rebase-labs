ENV['APP_ENV'] = 'test'

require 'simplecov'
SimpleCov.start do
  # add_filter Dir.pwd.concat('/import_from_csv.rb')
end

require_relative '../server'
require 'rack/test'
require 'rspec'
require 'debug'
require 'pg'

TEST_DB = {
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
    @conn = PG.connect(TEST_DB)
    @conn.exec('BEGIN')
  end

  config.after(:each) do
    @conn.exec('ROLLBACK') unless @conn.transaction_status.zero?
    @conn.exec('TRUNCATE TABLE patients RESTART IDENTITY;')
    @conn.exec('TRUNCATE TABLE exames RESTART IDENTITY;')
    @conn.close
  end
end
