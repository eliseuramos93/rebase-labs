DB_CONFIG = {
  dbname: 'postgres',
  user: 'postgres',
  password: 'postgres',
  port: '5432',
  host: 'postgres'
}.freeze

require_relative './lib/services/database_service'

connection = PG.connect(DB_CONFIG)
first_query = connection.exec('SELECT * FROM exames;')

if first_query.num_tuples == 0
  file_path = File.join(Dir.pwd, 'data.csv')
  DatabaseService.insert_data(file_path:, connection:)
  connection.close
end
