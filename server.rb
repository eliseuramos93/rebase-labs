require 'sinatra'
require 'rack/handler/puma'
require_relative 'lib/strategies/csv_conversion_strategy'
require_relative 'lib/services/database_service'

get '/tests' do
  content_type :json

  connection = DatabaseService.connect
  DatabaseService.select_all_tests(connection:)
end

get '/hello' do
  'Hello world!'
end

Rack::Handler::Puma.run(Sinatra::Application, Port: 3000, Host: '0.0.0.0') unless ENV['APP_ENV'] == 'test'
