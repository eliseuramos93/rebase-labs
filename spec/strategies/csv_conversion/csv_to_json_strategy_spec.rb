require 'spec_helper'
require_relative '../../../lib/strategies/csv_conversion_strategy'

RSpec.describe CSVToJsonStrategy do
  context '#convert' do
    it 'converte um arquivo CSV para JSON' do
      file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'test_data.csv')

      results = CSVToJsonStrategy.convert(file_path)
      json_results = JSON.parse(results)

      expect(json_results.first['cpf']).to eq '048.973.170-88'
      expect(json_results.first['nome paciente']).to eq 'Emilly Batista Neto'
      expect(json_results.first['email paciente']).to eq 'gerald.crona@ebert-quigley.com'
      expect(json_results.first['data nascimento paciente']).to eq '2001-03-11'
      expect(json_results.first['endereço/rua paciente']).to eq '165 Rua Rafaela'
      expect(json_results.first['cidade paciente']).to eq 'Ituverava'
      expect(json_results.first['estado patiente']).to eq 'Alagoas'
      expect(json_results.first['crm médico']).to eq 'B000BJ20J4'
      expect(json_results.first['crm médico estado']).to eq 'PI'
      expect(json_results.first['nome médico']).to eq 'Maria Luiza Pires'
      expect(json_results.first['email médico']).to eq 'denna@wisozk.biz'
      expect(json_results.first['resultado tipo exame']).to eq '97'
      expect(json_results.first['token resultado exame']).to eq 'IQCZ17'
      expect(json_results.first['data exame']).to eq '2021-08-05'
      expect(json_results.first['tipo exame']).to eq 'hemácias'
      expect(json_results.first['limites tipo exame']).to eq '45-52'
    end
  end
end
