require 'spec_helper'
require_relative '../../lib/services/database_service'

RSpec.describe DatabaseService do
  context '#insert_data' do
    it 'insere os dados no banco de dados com sucesso' do
      file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'test_data.csv')

      DatabaseService.insert_data(file_path:, connection: @conn)
      result = @conn.exec('SELECT * FROM exames;')

      expect(result.num_tuples).to eq 1
      expect(result.first['cpf']).to eq '048.973.170-88'
      expect(result.first['nome paciente']).to eq 'Emilly Batista Neto'
      expect(result.first['email paciente']).to eq 'gerald.crona@ebert-quigley.com'
      expect(result.first['data nascimento paciente']).to eq '2001-03-11'
      expect(result.first['endereço/rua paciente']).to eq '165 Rua Rafaela'
      expect(result.first['cidade paciente']).to eq 'Ituverava'
      expect(result.first['estado patiente']).to eq 'Alagoas'
      expect(result.first['crm médico']).to eq 'B000BJ20J4'
      expect(result.first['crm médico estado']).to eq 'PI'
      expect(result.first['nome médico']).to eq 'Maria Luiza Pires'
      expect(result.first['email médico']).to eq 'denna@wisozk.biz'
      expect(result.first['resultado tipo exame']).to eq '97'
      expect(result.first['token resultado exame']).to eq 'IQCZ17'
      expect(result.first['data exame']).to eq '2021-08-05'
      expect(result.first['tipo exame']).to eq 'hemácias'
      expect(result.first['limites tipo exame']).to eq '45-52'
    end

    it 'não altera o banco de dados caso o arquivo CSV esteja em branco' do
      file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'blank_test_data.csv')

      DatabaseService.insert_data(file_path:, connection: @conn)
      result = @conn.exec('SELECT * FROM exames;')

      expect(result.num_tuples).to eq 0
    end

    it 'não altera o banco de dados caso o arquivo CSV possua colunas diferentes do banco de dados' do
      file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'invalid_column_test_data.csv')

      DatabaseService.insert_data(file_path:, connection: @conn)
      result = @conn.exec('SELECT * FROM exames;')

      expect(result.num_tuples).to eq 0
    end
  end
end
