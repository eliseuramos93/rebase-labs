ENV['APP_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require_relative '../server'
require 'rack/test'
require 'rspec'
require 'debug'

RSpec.configure do |config|
  include Rack::Test::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end