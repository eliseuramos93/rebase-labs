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
    it 'Usuário consulta a tabela de exames com sucesso', js: true do
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

    it 'Usuário pesquisa um exame usando o token e carrega os detalhes do exame com sucesso', js: true do
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

    it 'Usuário pesquisa um exame usando o token mas não executa a busca com o campo de busca vazio', js: true do
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

    it 'Usuário pesquisa um exame usando o token e recebe um alerta de erro se nada for encontrado', js: true do
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

    it 'Usuário pesquisa um exame usando o token e recebe um alerta de erro se o BD estiver indisponível', js: true do
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
end
