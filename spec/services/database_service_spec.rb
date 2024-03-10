require 'spec_helper'
require 'json'
require_relative '../../lib/services/database_service'

RSpec.describe DatabaseService do
  context '::connect' do
    it 'conecta ao banco de dados com sucesso' do
      connection = DatabaseService.connect

      expect(connection.status).to eq PG::Constants::CONNECTION_OK
      expect(connection.host).to eq 'postgres-test'
      expect(connection.db).to eq 'postgres-test'
      expect(connection.port).to eq 5432
      connection.close
    end
  end
end
