ENV['APP_ENV'] = 'test'

require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require_relative '../server'
require_relative '../lib/services/database_service'
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

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.example_status_persistence_file_path = './spec/support/failures.txt'

  # Configurações para testes usando o banco de dados de teste

  config.after(:each) do
    @conn = PG.connect(TEST_DB_CONFIG)
    @conn.exec('SET client_min_messages TO ERROR;')
    @conn.exec('TRUNCATE patients, doctors RESTART IDENTITY CASCADE;')
    @conn.close
  end
end
