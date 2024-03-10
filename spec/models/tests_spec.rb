require 'spec_helper'
require_relative '../../lib/models/patient_model'
require_relative '../../lib/models/doctor_model'
require_relative '../../lib/models/examination_model'
require_relative '../../lib/models/test_model'

RSpec.describe Test do
  context 'quando inicializado' do
    it 'armazena as informações corretas no objeto' do
      patient = Patient.new(id: 13, cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                            birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.new(id: 27, crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                          email: 'wewereonabreak@gmail.com')
      examination = Examination.new(id: 93, patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                    date: '2023-10-31')
      test = Test.new(examination_id: examination.id, type: 'Hemácias',
                      limits: '45-52', results: '97')

      expect(test.examination_id).to eq 93
      expect(test.type).to eq 'Hemácias'
      expect(test.limits).to eq '45-52'
      expect(test.results).to eq '97'
    end
  end

  context '::create' do
    it 'consiste no banco de dados as informações do exame' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                         date: '2023-10-31')

      test = Test.create(examination_id: 1, type: 'Hemácias', limits: '45-52', results: '97')

      expect(test.id).to eq 1
      expect(test.examination_id).to eq 1
      expect(test.type).to eq 'Hemácias'
      expect(test.limits).to eq '45-52'
      expect(test.results).to eq '97'
    end

    it 'não cria um novo teste caso o exame não exista' do
      test = Test.create(examination_id: 1, type: 'Hemácias', limits: '45-52', results: '97')

      expect(test).to be_nil
    end

    it 'não cria um novo teste caso o exame não seja informado' do
      test = Test.create(examination_id: nil, type: 'Hemácias', limits: '45-52', results: '97')

      expect(test).to be_nil
    end

    it 'não cria um novo teste caso o tipo não seja informado' do
      test = Test.create(examination_id: 1, type: nil, limits: '45-52', results: '97')

      expect(test).to be_nil
    end

    it 'não cria um novo teste caso os limites não sejam informados' do
      test = Test.create(examination_id: 1, type: 'Hemácias', limits: nil, results: '97')

      expect(test).to be_nil
    end

    it 'não cria um novo teste caso os resultados não sejam informados' do
      test = Test.create(examination_id: 1, type: 'Hemácias', limits: '45-52', results: nil)

      expect(test).to be_nil
    end
  end

  context '::find' do
    it 'retorna um objeto do tipo Teste com as informações do teste' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      examination = Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                       date: '2023-10-31')
      Test.create(examination_id: examination.id, type: 'Hemácias', limits: '45-52', results: '97')

      test = Test.find(id: 1)

      expect(test).to be_an_instance_of(Test)
      expect(test.id).to eq 1
      expect(test.examination_id).to eq 1
      expect(test.type).to eq 'Hemácias'
      expect(test.limits).to eq '45-52'
      expect(test.results).to eq '97'
    end

    it 'retorna nil se o teste não for encontrado' do
      test = Test.find(id: 1)

      expect(test).to be_nil
    end
  end

  context '::find_by' do
    it 'retorna um objeto do tipo Teste com as informações do teste' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      examination = Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                       date: '2023-10-31')
      Test.create(examination_id: examination.id, type: 'Hemácias', limits: '45-52', results: '97')

      test = Test.find_by(type: 'Hemácias', limits: '45-52', results: '97')

      expect(test).to be_an_instance_of(Test)
      expect(test.id).to eq 1
      expect(test.examination_id).to eq 1
      expect(test.type).to eq 'Hemácias'
      expect(test.limits).to eq '45-52'
      expect(test.results).to eq '97'
    end

    it 'retorna nil se o teste não for encontrado' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                             email: 'wewereonabreak@gmail.com')
      examination = Examination.create(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                       date: '2023-10-31')
      Test.create(examination_id: examination.id, type: 'Hemácias', limits: '45-52', results: '97')

      test = Test.find_by(type: 'Leucócitos', limits: '45-52', results: '98')

      expect(test).to be_nil
    end

    it 'retorna nil quando nenhum parâmetro é informado' do
      test = Test.find_by

      expect(test).to be_nil
    end

    it 'retorna nil quando os parâmetros informados não existem' do
      test = Test.find_by(type: 'Hemácias', limits: '45-52', results: '97')

      expect(test).to be_nil
    end
  end
end
