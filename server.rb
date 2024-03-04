require 'sinatra'
require 'rack/handler/puma'
require_relative 'lib/strategies/csv_conversion_strategy'

get '/tests' do
  content_type :json
  csv_converter = CSVConverter.new(CSVToJsonStrategy)
  csv_converter.convert('./data.csv')
end

get '/hello' do
  'Hello world!'
end

Rack::Handler::Puma.run(Sinatra::Application, Port: 3000, Host: '0.0.0.0') unless ENV['APP_ENV'] == 'test'
