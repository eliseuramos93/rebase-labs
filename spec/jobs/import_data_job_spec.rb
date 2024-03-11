require 'spec_helper'
require_relative '../../lib/jobs/import_data_job'

RSpec.describe ImportDataJob do
  it 'inserts data into the database' do
    file_path = File.join(Dir.pwd, 'spec', 'support', 'assets', 'csvs', 'test_data.csv')

    ImportDataJob.perform_inline(file_path)
    connection = DatabaseService.connect
    results = connection.exec('SELECT * FROM patients')
    connection.close

    expect(results.ntuples).to eq(4)
    expect(results[0]['cpf']).to eq '048.973.170-88'
    expect(results[1]['cpf']).to eq '066.126.400-90'
    expect(results[2]['cpf']).to eq '089.034.562-70'
    expect(results[3]['cpf']).to eq '077.411.587-40'
  end
end
