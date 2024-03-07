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

get '/home' do
  content_type 'text/html'

  path = File.join(Dir.pwd, 'public', 'index.html')
  File.open(path)
end
