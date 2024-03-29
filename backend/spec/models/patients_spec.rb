require 'spec_helper'
require_relative '../../lib/models/patient_model'

RSpec.describe Patient do
  context 'quando inicializado' do
    it 'armazena as informações corretas no objeto' do
      patient = Patient.new(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                            birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')

      expect(patient.cpf).to eq '283.368.670-66'
      expect(patient.full_name).to eq 'Reginaldo Rossi'
      expect(patient.email).to eq 'reidobrega@gmail.com'
      expect(patient.birth_date).to eq '1944-02-14'
      expect(patient.address).to eq '200 Rua do Garçom'
      expect(patient.city).to eq 'Recife'
      expect(patient.state).to eq 'PE'
    end
  end

  context '::create' do
    it 'consiste no banco de dados as informações do paciente' do
      patient = Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                               birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE',
                               end_connection: false)

      expect(patient.id).to eq 1
      expect(patient.cpf).to eq '283.368.670-66'
      expect(patient.full_name).to eq 'Reginaldo Rossi'
      expect(patient.email).to eq 'reidobrega@gmail.com'
      expect(patient.birth_date).to eq '1944-02-14'
      expect(patient.address).to eq '200 Rua do Garçom'
      expect(patient.city).to eq 'Recife'
      expect(patient.state).to eq 'PE'
    end

    it 'não cria um novo paciente caso o CPF já exista' do
      Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                     birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE',
                     end_connection: false)

      Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                     birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE',
                     end_connection: false)

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM patients;')
      connection.close

      expect(results.count).to eq 1
    end

    it 'não cria um novo paciente caso o CPF não seja informado' do
      Patient.create(cpf: nil, full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                     birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE',
                     end_connection: false)

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM patients;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'e não cria um novo paciente se o nome não for informado' do
      Patient.create(cpf: '283.368.670-66', full_name: nil, email: 'reidobrega@gmail.com',
                     birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE',
                     end_connection: false)

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM patients;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'e não cria um novo paciente se o email não for informado' do
      Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: nil,
                     birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE',
                     end_connection: false)

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM patients;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'e não cria um novo paciente se a data de nascimento não for informada' do
      Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                     birth_date: nil, address: '200 Rua do Garçom', city: 'Recife', state: 'PE',
                     end_connection: false)

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM patients;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'e não cria um novo paciente se o endereço não for informado' do
      Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                     birth_date: '1944-02-14', address: nil, city: 'Recife', state: 'PE',
                     end_connection: false)

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM patients;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'e não cria um novo paciente se a cidade não for informada' do
      Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                     birth_date: '1944-02-14', address: '200 Rua do Garçom', city: nil, state: 'PE',
                     end_connection: false)

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM patients;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'e não cria um novo paciente se o estado não for informado' do
      Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                     birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: nil,
                     end_connection: false)

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM patients;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'é capaz de criar uma conexão com o banco de dados caso uma não seja fornecida' do
      Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                     birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM patients;')
      connection.close

      expect(results.count).to eq 1
    end
  end

  context '::find' do
    it 'retorna um objeto paciente com as informações corretas' do
      Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                     birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE',
                     end_connection: false)

      found_patient = Patient.find(id: 1, end_connection: false)

      expect(found_patient).to be_a Patient
      expect(found_patient.id).to eq 1
      expect(found_patient.cpf).to eq '283.368.670-66'
      expect(found_patient.full_name).to eq 'Reginaldo Rossi'
      expect(found_patient.email).to eq 'reidobrega@gmail.com'
      expect(found_patient.birth_date).to eq '1944-02-14'
      expect(found_patient.address).to eq '200 Rua do Garçom'
      expect(found_patient.city).to eq 'Recife'
      expect(found_patient.state).to eq 'PE'
    end

    it 'retorna nil caso nenhum paciente seja encontrado' do
      found_patient = Patient.find(id: 1, end_connection: false)

      expect(found_patient).to be_nil
    end
  end

  context '::find_by' do
    it 'retorna um objeto do tipo Patient quando a pesquisa é feita com sucesso' do
      Patient.create(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                     birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')

      found_patient = Patient.find_by(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi',
                                      email: 'reidobrega@gmail.com', birth_date: '1944-02-14',
                                      address: '200 Rua do Garçom', city: 'Recife', state: 'PE')

      expect(found_patient.id).to eq 1
      expect(found_patient.cpf).to eq '283.368.670-66'
      expect(found_patient.full_name).to eq 'Reginaldo Rossi'
      expect(found_patient.email).to eq 'reidobrega@gmail.com'
      expect(found_patient.birth_date).to eq '1944-02-14'
      expect(found_patient.address).to eq '200 Rua do Garçom'
      expect(found_patient.city).to eq 'Recife'
      expect(found_patient.state).to eq 'PE'
    end

    it 'retorna nil quando nenhum parâmetro é informado' do
      found_patient = Patient.find_by

      expect(found_patient).to be_nil
    end

    it 'retorna nil quando a pesquisa não encontra nada' do
      found_patient = Patient.find_by(cpf: '123.456.789-00')

      expect(found_patient).to be_nil
    end

    it 'retorna nil se uma coluna inválida é informada' do
      found_patient = Patient.find_by(potato: 'hello')

      expect(found_patient).to be_nil
    end
  end
end
