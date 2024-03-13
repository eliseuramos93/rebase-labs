ENV['APP_ENV'] = 'test'

TEST_DB = {
  dbname: 'postgres-test',
  user: 'postgres-test',
  password: '654321',
  port: '5432',
  host: 'postgres-test'
}.freeze

require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require_relative '../server'
require 'capybara/rspec'
require 'debug'
require 'pg'
require 'rack/test'
require 'rspec'
require 'selenium-webdriver'
require 'webdriver'

Capybara.app = Sinatra::Application
Capybara.server = :puma, { Silent: true }
Capybara.javascript_driver = :selenium_headless
Capybara.default_driver = :rack_test

RSpec.configure do |config|
  include Rack::Test::Methods
  Capybara.server_port = 4242

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
    @conn.exec('SET client_min_messages TO warning;')
  end

  config.after(:each) do
    # @conn.exec('ROLLBACK') unless @conn.finished?
    @conn.exec('TRUNCATE TABLE patients RESTART IDENTITY CASCADE;')
    @conn.exec('TRUNCATE TABLE doctors RESTART IDENTITY CASCADE;')
    @conn.exec('TRUNCATE TABLE examinations RESTART IDENTITY CASCADE;')
    @conn.close
  end
end
