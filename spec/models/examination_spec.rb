require 'spec_helper'
require_relative '../../lib/models/examination_model'
require_relative '../../lib/models/patient_model'
require_relative '../../lib/models/doctor_model'

RSpec.describe Examination do
  context 'quando inicializado' do
    it 'armazena as informações corretas no objeto' do
      patient = Patient.new(id: 13, cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                            birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.new(id: 27, crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                          email: 'wewereonabreak@gmail.com')

      examination = Examination.new(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                    date: '2023-10-31')

      expect(examination.patient_id).to eq 13
      expect(examination.doctor_id).to eq 27
      expect(examination.result_token).to eq 'SCCP10'
      expect(examination.date).to eq '2023-10-31'
    end
  end

  context '::create' do
    it 'consiste no banco de dados as informações do exame' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmailcom',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')

      examination = Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                       date: '2023-10-31')

      expect(examination.id).to eq 1
      expect(examination.patient_id).to eq 1
      expect(examination.doctor_id).to eq 1
      expect(examination.result_token).to eq 'SCCP10'
      expect(examination.date).to eq '2023-10-31'
    end

    it 'não cria um novo exame caso o token do resultado já exista' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmailcom',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                         date: '2023-10-31')

      Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10', date: '2023-10-31')

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM examinations;')
      connection.close

      expect(results.count).to eq 1
    end

    it 'não cria um novo exame caso o paciente não exista' do
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')

      Examination.create(patient_id: 1, doctor_id: doctor.id, result_token: 'SCCP10', date: '2023-10-31')

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM examinations;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'não cria um novo exame caso o médico não exista' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmailcom',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')

      Examination.create(patient_id: patient.id, doctor_id: 1, result_token: 'SCCP10', date: '2023-10-31')

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM examinations;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'não cria um novo exame caso o token do resultado não seja informado' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmailcom',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')

      Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: nil, date: '2023-10-31')
      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM examinations;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'não cria um novo exame caso a data não seja informada' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmailcom',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')

      Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10', date: nil)
      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM examinations;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'não cria um novo exame caso o paciente não seja informado' do
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')

      Examination.create(patient_id: nil, doctor_id: doctor.id, result_token: 'SCCP10', date: '2023-10-31')
      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM examinations;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'não cria um novo exame caso o médico não seja informado' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmailcom',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')

      Examination.create(patient_id: patient.id, doctor_id: nil, result_token: 'SCCP10', date: '2023-10-31')
      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM examinations;')
      connection.close

      expect(results.count).to eq 0
    end
  end

  context '::find' do
    it 'retorna um objeto do tipo Examination com as informações corretas' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmailcom',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                         date: '2023-10-31')

      found_examination = Examination.find(id: 1)

      expect(found_examination).to be_an_instance_of(Examination)
      expect(found_examination.id).to eq 1
      expect(found_examination.patient_id).to eq 1
      expect(found_examination.doctor_id).to eq 1
      expect(found_examination.result_token).to eq 'SCCP10'
      expect(found_examination.date).to eq '2023-10-31'
    end

    it 'retorna nil se o exame não for encontrado' do
      found_examination = Examination.find(id: 1)

      expect(found_examination).to be_nil
    end
  end

  context '::find_by' do
    it 'retorna um objeto do tipo Examination com as informações corretas' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmailcom',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                         date: '2023-10-31')

      found_examination = Examination.find_by(result_token: 'SCCP10')

      expect(found_examination).to be_an_instance_of(Examination)
      expect(found_examination.id).to eq 1
      expect(found_examination.patient_id).to eq 1
      expect(found_examination.doctor_id).to eq 1
      expect(found_examination.result_token).to eq 'SCCP10'
      expect(found_examination.date).to eq '2023-10-31'
    end

    it 'retorna nil se o exame não for encontrado' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmailcom',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                         date: '2023-10-31')

      found_examination = Examination.find_by(result_token: 'SCCP1910', date: '2023-10-31', patient_id: 1, doctor_id: 1)

      expect(found_examination).to be_nil
    end

    it 'retorna nil quando nenhum parâmetro é informado' do
      found_examination = Examination.find_by

      expect(found_examination).to be_nil
    end

    it 'retorna nil se uma coluna inválida é informada' do
      found_examination = Examination.find_by(invalid_column: 'invalid_value')

      expect(found_examination).to be_nil
    end
  end
end