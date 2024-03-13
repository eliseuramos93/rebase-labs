require 'spec_helper'
require_relative '../../lib/jobs/import_data_job'

def app
  Sinatra::Application
end

RSpec.describe Sinatra::Application, type: :request do
  context 'GET /tests' do
    it 'retorna um arquivo JSON com o resultado dos testes' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      examination = Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                       date: '2023-10-31')
      Test.create(examination_id: examination.id, type: 'Hemácias', limits: '45-52', results: '97')
      Test.create(examination_id: examination.id, type: 'Glóbulos Neutrônicos', limits: '2-8', results: '5')

      get '/tests'

      expect(last_response).to be_ok
      expect(last_response.content_type).to include 'application/json'
      json_response = JSON.parse(last_response.body)
      expect(json_response.class).to be Array
      expect(json_response.count).to eq 1
      expect(json_response[0]['result_token']).to eq 'SCCP10'
      expect(json_response[0]['date']).to eq '2023-10-31'
      expect(json_response[0]['cpf']).to eq '283.368.670-66'
      expect(json_response[0]['full_name']).to eq 'Reginaldo Rossi'
      expect(json_response[0]['email']).to eq 'reidobrega@gmail.com'
      expect(json_response[0]['birth_date']).to eq '1944-02-14'
      expect(json_response[0]['doctor']['crm']).to eq 'B000BJ20J4'
      expect(json_response[0]['doctor']['crm_state']).to eq 'PI'
      expect(json_response[0]['doctor']['full_name']).to eq 'Dr. Ross Geller'
      expect(json_response[0]['tests'][0]['type']).to eq 'Glóbulos Neutrônicos'
      expect(json_response[0]['tests'][0]['limits']).to eq '2-8'
      expect(json_response[0]['tests'][0]['results']).to eq '5'
      expect(json_response[0]['tests'][1]['type']).to eq 'Hemácias'
      expect(json_response[0]['tests'][1]['limits']).to eq '45-52'
      expect(json_response[0]['tests'][1]['results']).to eq '97'
    end

    it 'retorna um array vazio se não houver exames cadastrados' do
      get '/tests'

      expect(last_response).to be_ok
      json_response = JSON.parse(last_response.body)
      expect(json_response).to eq []
    end

    it 'retorna uma mensagem de erro caso a conexão com o banco de dados falhe' do
      allow(DatabaseService).to receive(:connect).and_raise(PG::ConnectionBad)

      get '/tests'

      expect(last_response).to be_ok
      json_response = JSON.parse(last_response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['errors']['message']).to eq 'Não foi possível conectar-se ao banco de dados.'
    end
  end

  context 'GET /tests/:result_token' do
    it 'retorna o teste pesquisado com sucesso' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      examination = Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                       date: '2023-10-31')
      Test.create(examination_id: examination.id, type: 'Hemácias', limits: '45-52', results: '97')
      Test.create(examination_id: examination.id, type: 'Glóbulos Neutrônicos', limits: '2-8', results: '5')

      get '/tests/SCCP10'

      expect(last_response).to be_ok
      expect(last_response.content_type).to include 'application/json'
      json_response = JSON.parse(last_response.body)
      expect(json_response.class).to be Hash
      expect(json_response['result_token']).to eq 'SCCP10'
      expect(json_response['date']).to eq '2023-10-31'
      expect(json_response['cpf']).to eq '283.368.670-66'
      expect(json_response['full_name']).to eq 'Reginaldo Rossi'
      expect(json_response['email']).to eq 'reidobrega@gmail.com'
      expect(json_response['birth_date']).to eq '1944-02-14'
      expect(json_response['doctor']['crm']).to eq 'B000BJ20J4'
      expect(json_response['doctor']['crm_state']).to eq 'PI'
      expect(json_response['doctor']['full_name']).to eq 'Dr. Ross Geller'
      expect(json_response['tests'][0]['type']).to eq 'Glóbulos Neutrônicos'
      expect(json_response['tests'][0]['limits']).to eq '2-8'
      expect(json_response['tests'][0]['results']).to eq '5'
      expect(json_response['tests'][1]['type']).to eq 'Hemácias'
      expect(json_response['tests'][1]['limits']).to eq '45-52'
      expect(json_response['tests'][1]['results']).to eq '97'
    end

    it 'retorna todos os testes caso result_token não seja informado' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      examination = Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                       date: '2023-10-31')
      Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP11',
                         date: '2023-09-01')
      Test.create(examination_id: examination.id, type: 'Hemácias', limits: '45-52', results: '97')
      Test.create(examination_id: examination.id, type: 'Glóbulos Neutrônicos', limits: '2-8', results: '5')

      get '/tests/'

      expect(last_response).to be_ok
      expect(last_response.content_type).to include 'application/json'
      json_response = JSON.parse(last_response.body)
      expect(json_response.class).to be Array
      expect(json_response.count).to eq 2
      expect(json_response[0]['result_token']).to eq 'SCCP10'
      expect(json_response[0]['date']).to eq '2023-10-31'
      expect(json_response[0]['cpf']).to eq '283.368.670-66'
      expect(json_response[0]['full_name']).to eq 'Reginaldo Rossi'
      expect(json_response[0]['email']).to eq 'reidobrega@gmail.com'
      expect(json_response[0]['birth_date']).to eq '1944-02-14'
      expect(json_response[0]['doctor']['crm']).to eq 'B000BJ20J4'
      expect(json_response[0]['doctor']['crm_state']).to eq 'PI'
      expect(json_response[0]['doctor']['full_name']).to eq 'Dr. Ross Geller'
      expect(json_response[0]['tests'][0]['type']).to eq 'Glóbulos Neutrônicos'
      expect(json_response[0]['tests'][0]['limits']).to eq '2-8'
      expect(json_response[0]['tests'][0]['results']).to eq '5'
      expect(json_response[0]['tests'][1]['type']).to eq 'Hemácias'
      expect(json_response[0]['tests'][1]['limits']).to eq '45-52'
      expect(json_response[0]['tests'][1]['results']).to eq '97'
    end

    it 'retorna uma mensagem de erro caso o token não exista' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      examination = Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                       date: '2023-10-31')
      Test.create(examination_id: examination.id, type: 'Hemácias', limits: '45-52', results: '97')
      Test.create(examination_id: examination.id, type: 'Glóbulos Neutrônicos', limits: '2-8', results: '5')

      get '/tests/batata'

      expect(last_response).to be_ok
      expect(last_response.content_type).to include 'application/json'
      json_response = JSON.parse(last_response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['errors']['message']).to eq 'Não foi encontrado nenhum exame com o token informado.'
    end

    it 'retorna uma mensagem de erro caso a conexão com o banco de dados falhe' do
      allow(DatabaseService).to receive(:connect).and_raise(PG::ConnectionBad)

      get '/tests/olamundo'

      expect(last_response).to be_ok
      expect(last_response.content_type).to include 'application/json'
      json_response = JSON.parse(last_response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['errors']['message']).to eq 'Não foi possível conectar-se ao banco de dados.'
    end
  end

  context 'POST /import' do
    it 'enfileira um job para importar os dados' do
      job_spy = spy('ImportDataJob')
      stub_const('ImportDataJob', job_spy)

      post '/import'

      expect(job_spy).to have_received(:perform_async).once
    end
  end
end
