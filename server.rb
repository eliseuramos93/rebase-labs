require 'sinatra'
require 'rack/handler/puma'
require_relative 'lib/models/examination_model'
require_relative 'lib/jobs/import_data_job'

get '/' do
  erb :index
end

get '/tests' do
  content_type :json

  Examination.select_all_to_json.to_json
end

get '/tests/:result_token?' do
  content_type :json
  return Examination.select_all_to_json.to_json unless params[:result_token]

  Examination.select_to_json(result_token: params[:result_token]).to_json
end

post '/import' do
  ImportDataJob.perform_async
end
