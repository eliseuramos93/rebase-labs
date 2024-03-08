DB_CONFIG = {
  dbname: 'postgres',
  user: 'postgres',
  password: 'postgres',
  port: '5432',
  host: 'postgres'
}.freeze

TEST_DB_CONFIG = {
  dbname: 'postgres-test',
  user: 'postgres-test',
  password: '654321',
  port: '5432',
  host: 'postgres-test'
}.freeze

require 'pg'
require 'json'

class DatabaseService
  def self.connect
    config = ENV['APP_ENV'] == 'test' ? TEST_DB_CONFIG : DB_CONFIG
    PG.connect(config)
  end

  def self.insert_data(json_data:, connection: nil)
    connection ||= DatabaseService.connect
    raise PG::UnableToSend unless connection.instance_of?(PG::Connection)

    json_data.each do |row|
      connection.exec(create_insert_sql(row))
    end
  rescue PG::UndefinedColumn
    connection.exec('ROLLBACK')
  end

  def self.select_all_tests(connection:)
    return unless connection.instance_of?(PG::Connection)

    connection.exec('SELECT * FROM exames;').map { |row| row }.to_json
  rescue PG::ConnectionBad
    nil
  end

  private_class_method def self.create_insert_sql(row)
    columns = row.keys.map { |key| "\"#{key}\"" }.join(', ')
    values = row.values.map { |value| "'#{value.gsub(/'/, "''")}'" }.join(', ')

    "INSERT INTO exames (#{columns}) VALUES (#{values});"
  end
end
