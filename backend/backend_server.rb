require 'sinatra'
require 'rack/handler/puma'
require_relative 'lib/models/examination_model'
require_relative 'lib/jobs/import_data_job'

get '/tests' do
  response.headers['Access-Control-Allow-Origin'] = 'frontend:3000'
  content_type :json

  Examination.select_all_to_json.to_json
end

get '/tests/:result_token?' do
  response.headers['Access-Control-Allow-Origin'] = 'frontend:3000'
  content_type :json
  return Examination.select_all_to_json.to_json unless params[:result_token]

  Examination.select_to_json(result_token: params[:result_token]).to_json
end

post '/import' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = 'frontend:3000'

  request.body.rewind
  data = request.body.read.force_encoding('UTF-8')
  ImportDataJob.perform_async(data)

  { message: 'Solicitação registrada com sucesso.' }.to_json
end
