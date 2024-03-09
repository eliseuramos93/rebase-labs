require 'sinatra'
require 'rack/handler/puma'
require_relative 'lib/models/examination_model'

get '/tests' do
  content_type :json

  Examination.all_to_json.to_json
end

get '/' do
  erb :index
end
