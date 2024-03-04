require 'spec_helper'

def app
  Sinatra::Application
end

RSpec.describe Sinatra::Application, type: :system do
  context 'GET /hello' do
    it 'fala Hello world! para o usuário' do
      get '/hello'

      expect(last_response).to be_ok
      expect(last_response.body).to include 'Hello world!'
    end
  end

  context 'GET /tests' do
    it 'retorna um arquivo JSON com o resultado dos testes' do
      get '/tests'

      expect(last_response).to be_ok
      expect(last_response.content_type).to include 'application/json'
      json_response = JSON.parse(last_response.body)
      expect(json_response.first['cpf']).to eq '048.973.170-88'
      expect(json_response.first['nome paciente']).to eq 'Emilly Batista Neto'
      expect(json_response.first['email paciente']).to eq 'gerald.crona@ebert-quigley.com'
      expect(json_response.first['data nascimento paciente']).to eq '2001-03-11'
      expect(json_response.first['endereço/rua paciente']).to eq '165 Rua Rafaela'
      expect(json_response.first['cidade paciente']).to eq 'Ituverava'
      expect(json_response.first['estado patiente']).to eq 'Alagoas'
      expect(json_response.first['crm médico']).to eq 'B000BJ20J4'
      expect(json_response.first['crm médico estado']).to eq 'PI'
      expect(json_response.first['nome médico']).to eq 'Maria Luiza Pires'
      expect(json_response.first['email médico']).to eq 'denna@wisozk.biz'
      expect(json_response.first['token resultado exame']).to eq 'IQCZ17'
      expect(json_response.first['data exame']).to eq '2021-08-05'
      expect(json_response.first['tipo exame']).to eq 'hemácias'
      expect(json_response.first['limites tipo exame']).to eq '45-52'
      expect(json_response.first['resultado tipo exame']).to eq '97'
    end
  end
end
