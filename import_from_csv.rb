require_relative './lib/services/database_service'
require_relative './lib/strategies/csv_conversion_strategy'
connection = DatabaseService.connect
entire_database_data = JSON.parse(DatabaseService.select_all_tests(connection:))

if entire_database_data.count.zero?
  file_path = File.join(Dir.pwd, 'data.csv')
  csv_converter = CSVConverter.new(CSVToJsonStrategy)
  json_data = JSON.parse(csv_converter.convert(file_path))

  DatabaseService.insert_data(json_data:, connection:)
end

connection.close
