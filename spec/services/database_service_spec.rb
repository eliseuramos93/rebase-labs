require 'spec_helper'
require 'json'
require_relative '../../lib/services/database_service'
require_relative '../../lib/strategies/csv_conversion_strategy'

RSpec.describe DatabaseService do
  context '::connect' do
    it 'conecta ao banco de dados com sucesso' do
      connection = DatabaseService.connect

      expect(connection.status).to eq PG::Constants::CONNECTION_OK
      expect(connection.host).to eq 'postgres'
      expect(connection.db).to eq 'postgres'
      expect(connection.port).to eq 5432
      connection.close
    end
  end

  context '::insert_data' do
    it 'insere os dados no banco de dados com sucesso' do
      file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'test_data.csv')
      converter = CSVConverter.new(CSVToJsonStrategy)
      json_data = JSON.parse(converter.convert(file_path))

      DatabaseService.insert_data(json_data:, connection: @conn)
      results = @conn.exec('SELECT * FROM exames;')

      expect(results.count).to eq 4
      expect(results[0]['cpf']).to eq '048.973.170-88'
      expect(results[0]['nome paciente']).to eq 'Emilly Batista Neto'
      expect(results[0]['email paciente']).to eq 'gerald.crona@ebert-quigley.com'
      expect(results[0]['data nascimento paciente']).to eq '2001-03-11'
      expect(results[0]['endereço/rua paciente']).to eq '165 Rua Rafaela'
      expect(results[0]['cidade paciente']).to eq 'Ituverava'
      expect(results[0]['estado patiente']).to eq 'Alagoas'
      expect(results[0]['crm médico']).to eq 'B000BJ20J4'
      expect(results[0]['crm médico estado']).to eq 'PI'
      expect(results[0]['nome médico']).to eq 'Maria Luiza Pires'
      expect(results[0]['email médico']).to eq 'denna@wisozk.biz'
      expect(results[0]['resultado tipo exame']).to eq '97'
      expect(results[0]['token resultado exame']).to eq 'IQCZ17'
      expect(results[0]['data exame']).to eq '2021-08-05'
      expect(results[0]['tipo exame']).to eq 'hemácias'
      expect(results[0]['limites tipo exame']).to eq '45-52'
    end

    it 'não altera o banco de dados caso o JSON esteja vazio' do
      file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'blank_test_data.csv')
      converter = CSVConverter.new(CSVToJsonStrategy)
      json_data = JSON.parse(converter.convert(file_path))

      DatabaseService.insert_data(json_data:, connection: @conn)
      result = @conn.exec('SELECT * FROM exames;')

      expect(result.count).to eq 0
    end

    it 'não altera o banco de dados caso o JSON possua colunas diferentes do banco de dados' do
      file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'invalid_column_test_data.csv')
      converter = CSVConverter.new(CSVToJsonStrategy)
      json_data = JSON.parse(converter.convert(file_path))

      DatabaseService.insert_data(json_data:, connection: @conn)
      result = @conn.exec('SELECT * FROM exames;')

      expect(result.count).to eq 0
    end

    it 'não altera o banco de dados caso a conexão esteje fechada' do
      file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'test_data.csv')
      converter = CSVConverter.new(CSVToJsonStrategy)
      json_data = JSON.parse(converter.convert(file_path))
      new_connection = PG.connect(TEST_DB_CONFIG)
      DatabaseService.insert_data(json_data:, connection: new_connection)

      new_connection.close

      expect { DatabaseService.insert_data(json_data:, connection: new_connection) }.to raise_error(PG::ConnectionBad)
      expect(@conn.exec('SELECT * FROM exames;').count).to eq 4
    end

    it 'não altera o banco de dados caso receba um argumento inválido na conexão' do
      file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'test_data.csv')
      converter = CSVConverter.new(CSVToJsonStrategy)
      json_data = JSON.parse(converter.convert(file_path))

      expect { DatabaseService.insert_data(json_data:, connection: nil) }.to raise_error(PG::UnableToSend)
      expect(@conn.exec('SELECT * FROM exames;').count).to eq 0
    end
  end

  context '::select_all_tests' do
    it 'retorna todas as linhas completas de um banco de dados com sucesso' do
      file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'test_data.csv')
      converter = CSVConverter.new(CSVToJsonStrategy)
      json_data = JSON.parse(converter.convert(file_path))
      DatabaseService.insert_data(json_data:, connection: @conn)

      results = DatabaseService.select_all_tests(connection: @conn)

      expect(results.class).to eq PG::Result
      expect(results.count).to eq 4
      expect(results[0]['cpf']).to eq '048.973.170-88'
      expect(results[1]['cpf']).to eq '066.126.400-90'
      expect(results[2]['cpf']).to eq '089.034.562-70'
      expect(results[3]['cpf']).to eq '077.411.587-40'
      expect(results[0]['nome paciente']).to eq 'Emilly Batista Neto'
      expect(results[0]['email paciente']).to eq 'gerald.crona@ebert-quigley.com'
      expect(results[0]['data nascimento paciente']).to eq '2001-03-11'
      expect(results[0]['endereço/rua paciente']).to eq '165 Rua Rafaela'
      expect(results[0]['cidade paciente']).to eq 'Ituverava'
      expect(results[0]['estado patiente']).to eq 'Alagoas'
      expect(results[0]['crm médico']).to eq 'B000BJ20J4'
      expect(results[0]['crm médico estado']).to eq 'PI'
      expect(results[0]['nome médico']).to eq 'Maria Luiza Pires'
      expect(results[0]['email médico']).to eq 'denna@wisozk.biz'
      expect(results[0]['resultado tipo exame']).to eq '97'
      expect(results[0]['token resultado exame']).to eq 'IQCZ17'
      expect(results[0]['data exame']).to eq '2021-08-05'
      expect(results[0]['tipo exame']).to eq 'hemácias'
      expect(results[0]['limites tipo exame']).to eq '45-52'
    end

    it 'retorna um resultado vazio se o banco de dados não possuir dados' do
      results = DatabaseService.select_all_tests(connection: @conn)

      expect(results.class).to eq PG::Result
      expect(results.count).to eq 0
    end

    it 'retorna nil caso a conexão esteja fechada' do
      connection = PG.connect(dbname: 'postgres-test', user: 'postgres-test', password: '654321', port: '5432',
                              host: 'postgres-test')
      connection.close

      expect { DatabaseService.select_all_tests(connection:) }.not_to raise_error
      expect(DatabaseService.select_all_tests(connection:)).to be_nil
    end

    it 'retorna nil caso não seja fornecida uma conexão' do
      invalid_argument = []

      result = DatabaseService.select_all_tests(connection: invalid_argument)

      expect(result).to be_nil
    end
  end
end
