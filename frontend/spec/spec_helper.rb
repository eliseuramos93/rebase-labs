require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require_relative '../frontend_server'
require 'capybara/rspec'
require 'debug'
require 'faraday'
require 'rack/test'
require 'rspec'
require 'selenium-webdriver'
require 'webdriver'

Capybara.app = Sinatra::Application
Capybara.server = :puma, { Silent: true }
Capybara.default_driver = :selenium_headless

def app
  Sinatra::Application
end

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
end
