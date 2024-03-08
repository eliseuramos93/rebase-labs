require 'spec_helper'
require_relative '../../lib/models/doctor_model'
require_relative '../../lib/services/database_service'

RSpec.describe Doctor do
  context 'quando inicializado' do
    it 'armazena as informações corretas no objeto' do
      doctor = Doctor.new(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                          email: 'wewereonabreak@gmail.com')

      expect(doctor.crm).to eq 'B000BJ20J4'
      expect(doctor.crm_state).to eq 'PI'
      expect(doctor.full_name).to eq 'Dr. Ross Geller'
      expect(doctor.email).to eq 'wewereonabreak@gmail.com'
    end
  end

  context '::create' do
    it 'consiste no banco de dados as informações do médico' do
      Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                    email: 'wewereonabreak@gmail.com', connection: @conn, end_connection: false)

      connect = DatabaseService.connect
      results = connect.exec('SELECT * FROM doctors;')
      connect.close

      expect(results.count).to eq 1
      expect(results.first['crm']).to eq 'B000BJ20J4'
      expect(results.first['crm_state']).to eq 'PI'
      expect(results.first['full_name']).to eq 'Dr. Ross Geller'
      expect(results.first['email']).to eq 'wewereonabreak@gmail.com'
    end

    it 'não cria um novo médico caso o CRM já exista' do
      Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                    email: 'wewereonabreak@gmail.com')
      Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                    email: 'wewereonabreak@gmail.com')

      connect = DatabaseService.connect
      results = connect.exec('SELECT * FROM doctors;')
      connect.close

      expect(results.count).to eq 1
    end

    it 'não cria um novo médico caso o CRM não seja informado' do
      Doctor.create(crm: nil, crm_state: 'PI', full_name: 'Dr. Ross Geller',
                    email: 'wewereonabreak@gmail.com')

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM doctors;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'não cria um novo médico caso o CRM State não seja informado' do
      Doctor.create(crm: 'B000BJ20J4', crm_state: nil, full_name: 'Dr. Ross Geller',
                    email: 'wewereonabreak@gmail.com')

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM doctors;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'não cria um novo médico caso o nome não seja informado' do
      Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: nil,
                    email: 'wewereonabreak@gmail.com')

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM doctors;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'não cria um novo médico caso o email não seja informado' do
      Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                    email: nil)

      connection = DatabaseService.connect
      results = connection.exec('SELECT * FROM doctors;')
      connection.close

      expect(results.count).to eq 0
    end

    it 'é capaz de criar uma conexão com o banco de dados caso uma não seja fornecida' do
      Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                    email: 'wewereonabreak@gmail.com')

      connection = PG.connect(TEST_DB)
      results = connection.exec('SELECT * FROM doctors;')
      connection.close

      expect(results.count).to eq 1
    end
  end

  context '::find' do
    it 'retorna um objeto do tipo Doctor com as informações corretas' do
      Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                    email: 'wewereonabreak@gmail.com')

      doctor = Doctor.find(id: 1, connection: @conn, end_connection: false)

      expect(doctor.id).to eq 1
      expect(doctor.crm).to eq 'B000BJ20J4'
      expect(doctor.crm_state).to eq 'PI'
      expect(doctor.full_name).to eq 'Dr. Ross Geller'
      expect(doctor.email).to eq 'wewereonabreak@gmail.com'
    end
  end

  context '::find_by' do
    it 'retorna um objeto do tipo Doctor quando a pesquisa é feita com sucesso' do
      Doctor.create(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                    email: 'wewereonabreak@gmail.com')

      doctor = Doctor.find_by(crm: 'B000BJ20J4')

      expect(doctor).to be_a(Doctor)
      expect(doctor.crm).to eq 'B000BJ20J4'
      expect(doctor.crm_state).to eq 'PI'
      expect(doctor.full_name).to eq 'Dr. Ross Geller'
      expect(doctor.email).to eq 'wewereonabreak@gmail.com'
    end

    it 'retorna nil quando nenhum parâmetro é informado' do
      doctor = Doctor.find_by

      expect(doctor).to be_nil
    end

    it 'retorna nil quando a pesquisa não encontra nada' do
      doctor = Doctor.find_by(crm: 'B000BJ20J5')

      expect(doctor).to be_nil
    end

    it 'retorna nil se uma coluna inválida é informada' do
      doctor = Doctor.find_by(potato: 'hello')

      expect(doctor).to be_nil
    end
  end
end
