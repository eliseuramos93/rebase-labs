require 'spec_helper'
require_relative '../../lib/services/database_service'
require_relative '../../lib/strategies/csv_conversion_strategy'
require_relative '../../lib/models/patient_model'
require_relative '../../lib/models/doctor_model'
require_relative '../../lib/models/examination_model'
require_relative '../../lib/models/test_model'

def app
  Sinatra::Application
end

RSpec.describe Sinatra::Application, type: :system do
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
      expect(json_response[0]['tests'][0]['type']).to eq 'Hemácias'
      expect(json_response[0]['tests'][0]['limits']).to eq '45-52'
      expect(json_response[0]['tests'][0]['results']).to eq '97'
      expect(json_response[0]['tests'][1]['type']).to eq 'Glóbulos Neutrônicos'
      expect(json_response[0]['tests'][1]['limits']).to eq '2-8'
      expect(json_response[0]['tests'][1]['results']).to eq '5'
    end
  end

  context 'GET /' do
    it 'retorna uma tabela com as informações dos exames', js: true do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                         date: '2023-10-31')

      visit '/'

      expect(page).to have_content 'Resultados dos Exames'
      expect(page).to have_content 'SCCP10'
      expect(page).to have_content '283.368.670-66'
      expect(page).to have_content 'Reginaldo Rossi'
      expect(page).to have_content 'reidobrega@gmail.com'
      expect(page).to have_content '1944-02-14'
      expect(page).to have_content 'B000BJ20J4'
      expect(page).to have_content 'PI'
      expect(page).to have_content 'Dr. Ross Geller'
    end
  end
end
