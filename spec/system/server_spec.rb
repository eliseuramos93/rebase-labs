require 'spec_helper'
require_relative '../../lib/services/database_service'
require_relative '../../lib/models/patient_model'
require_relative '../../lib/models/doctor_model'
require_relative '../../lib/models/examination_model'
require_relative '../../lib/models/test_model'

def app
  Sinatra::Application
end

RSpec.describe Sinatra::Application, type: :system do
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

    it 'carrega as informações do exame pesquisado através do formulário com sucesso', js: true do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      examination = Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                       date: '2023-10-31')
      Test.create(examination_id: examination.id, type: 'Hemácias', limits: '45-52', results: '97')
      Test.create(examination_id: examination.id, type: 'Glóbulos Neutrônicos', limits: '2-8', results: '5')

      visit '/'
      fill_in 'Token do exame', with: 'SCCP10'
      click_button 'Buscar'

      expect(page).to have_current_path '/'

      expect(page).to have_content 'Exame encontrado com sucesso!'
      expect(page).to have_content "Exame:\nSCCP10"
      expect(page).to have_content "Data do resultado (AAAA-MM-DD):\n2023-10-31"
      expect(page).to have_content "CPF:\n283.368.670-66"
      expect(page).to have_content "Nome:\nReginaldo Rossi"
      expect(page).to have_content "E-mail:\nreidobrega@gmail.com"
      expect(page).to have_content "Data de nascimento (AAAA-MM-DD):\n1944-02-14"
      expect(page).to have_content "Médico(a):\nDr. Ross Geller"
      expect(page).to have_content "CRM:\nB000BJ20J4"
      expect(page).to have_content "Estado do CRM:\nPI"
      expect(page).to have_content 'Hemácias'
      expect(page).to have_content 'Limites'
      expect(page).to have_content '45-52'
      expect(page).to have_content 'Resultado'
      expect(page).to have_content '97'
      expect(page).to have_content 'Glóbulos Neutrônicos'
      expect(page).to have_content '2-8'
      expect(page).to have_content '5'
    end

    it 'não executa a busca caso o campo de pesquisa esteja vazio', js: true do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      examination = Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                       date: '2023-10-31')
      Test.create(examination_id: examination.id, type: 'Hemácias', limits: '45-52', results: '97')
      Test.create(examination_id: examination.id, type: 'Glóbulos Neutrônicos', limits: '2-8', results: '5')

      visit '/'
      fill_in 'Token do exame', with: ''
      click_button 'Buscar'

      expect(page).to have_current_path '/'
      expect(page).to have_content 'É necessário informar o código do exame para realizar a busca.'
      expect(page).not_to have_button 'Voltar para a lista'
      expect(page).not_to have_content 'Exame encontrado com sucesso!'
      expect(page).to have_content 'SCCP10'
      expect(page).to have_content '2023-10-31'
      expect(page).to have_content '283.368.670-66'
      expect(page).to have_content 'Reginaldo Rossi'
      expect(page).to have_content 'reidobrega@gmail.com'
      expect(page).to have_content '1944-02-14'
      expect(page).to have_content 'Dr. Ross Geller'
      expect(page).to have_content 'B000BJ20J4'
      expect(page).to have_content 'PI'
      expect(page).not_to have_content 'Hemácias'
      expect(page).not_to have_content 'Glóbulos Neutrônicos'
      expect(page).not_to have_content 'Limites'
      expect(page).not_to have_content '45-52'
      expect(page).not_to have_content '2-8'
      expect(page).not_to have_content '97'
      expect(page).not_to have_content '5'
    end

    it 'informa uma mensagem de erro caso o exame pesquisado não seja encontrado', js: true do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      examination = Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                       date: '2023-10-31')
      Test.create(examination_id: examination.id, type: 'Hemácias', limits: '45-52', results: '97')
      Test.create(examination_id: examination.id, type: 'Glóbulos Neutrônicos', limits: '2-8', results: '5')

      visit '/'
      fill_in 'Token do exame', with: 'SCCP1910'
      click_button 'Buscar'

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Não foi encontrado nenhum exame com o token informado.'
      expect(page).not_to have_content 'Hemácias'
      expect(page).not_to have_content 'Glóbulos Neutrônicos'
    end

    it 'informa uma mensagem de erro caso o banco de dados não esteja disponível', js: true do
      allow(DatabaseService).to receive(:connect).and_raise(PG::ConnectionBad)

      visit '/'
      fill_in 'Token do exame', with: 'SCCP1910'
      click_button 'Buscar'

      expect(page).to have_current_path '/'
      expect(page).to have_content 'Não foi possível conectar-se ao banco de dados.'
      expect(page).not_to have_content 'Hemácias'
      expect(page).not_to have_content 'Glóbulos Neutrônicos'
    end

    it 'retorna para a lista de exames caso o botão "Voltar para a lista" seja clicado', js: true do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      examination = Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                       date: '2023-10-31')
      Test.create(examination_id: examination.id, type: 'Hemácias', limits: '45-52', results: '97')
      Test.create(examination_id: examination.id, type: 'Glóbulos Neutrônicos', limits: '2-8', results: '5')

      visit '/'
      fill_in 'Token do exame', with: 'SCCP10'
      click_on 'Buscar'
      click_on 'Voltar para a lista'

      expect(page).to have_current_path '/'
      expect(page).not_to have_button 'Voltar para a lista'
      expect(page).not_to have_content 'Exame encontrado com sucesso!'
      expect(page).to have_content 'SCCP10'
      expect(page).to have_content '2023-10-31'
      expect(page).to have_content '283.368.670-66'
      expect(page).to have_content 'Reginaldo Rossi'
      expect(page).to have_content 'reidobrega@gmail.com'
      expect(page).to have_content '1944-02-14'
      expect(page).to have_content 'Dr. Ross Geller'
      expect(page).to have_content 'B000BJ20J4'
      expect(page).to have_content 'PI'
      expect(page).not_to have_content 'Hemácias'
      expect(page).not_to have_content 'Glóbulos Neutrônicos'
      expect(page).not_to have_content 'Limites'
      expect(page).not_to have_content '45-52'
      expect(page).not_to have_content '2-8'
      expect(page).not_to have_content '97'
      expect(page).not_to have_content '5'
    end
  end

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
end
