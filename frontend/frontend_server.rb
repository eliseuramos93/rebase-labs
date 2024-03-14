require 'faraday'
require 'rack/handler/puma'
require 'sinatra'

API_SERVER_ERROR = { "errors": { "message": 'O servidor está indisponível no momento' } }.freeze

get '/' do
  erb :index
end

get '/tests' do
  content_type :json

  faraday_response = Faraday.get('http://backend:4000/tests')
  return API_SERVER_ERROR.to_json if faraday_response.status == 500

  faraday_response.body
end

get '/tests/:result_token?' do
  content_type :json

  faraday_response = Faraday.get("http://backend:4000/tests/#{params[:result_token]}")
  return API_SERVER_ERROR.to_json if faraday_response.status == 500

  faraday_response.body
end

post '/import' do
  request.body.rewind
  faraday_response = Faraday.post('http://backend:4000/import', request.body.read.force_encoding('UTF-8'))
  return API_SERVER_ERROR.to_json if faraday_response.status == 500

  faraday_response.body
end
