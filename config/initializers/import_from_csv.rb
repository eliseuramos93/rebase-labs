require_relative '../../lib/services/database_service'
require_relative '../../lib/strategies/csv_conversion_strategy'

# Conectar ao banco de dados e buscar todos os exames cadastrados
connection = DatabaseService.connect
entire_database_data = JSON.parse(DatabaseService.select_all_tests(connection:))

if entire_database_data.count.zero?
  # Povoar o banco de dados com os dados de data.csv, caso esteje vazio
  file_path = File.join(Dir.pwd, 'config', 'initializers', 'data.csv')
  csv_converter = CSVConverter.new(CSVToJsonStrategy)
  json_data = JSON.parse(csv_converter.convert(file_path))

  DatabaseService.insert_data(json_data:, connection:)
end

# Encerrar conexão com banco de dados
connection.close
