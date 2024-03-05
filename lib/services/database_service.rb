DB_CONFIG = {
  dbname: 'postgres',
  user: 'postgres',
  password: 'postgres',
  port: '5432',
  host: 'postgres'
}.freeze

require 'pg'

class DatabaseService
  def self.connect
    PG.connect(DB_CONFIG)
  end

  def self.insert_data(json_data:, connection:)
    raise PG::UnableToSend unless connection.instance_of?(PG::Connection)

    json_data.each do |row|
      connection.exec(create_insert_sql(row))
    end
  rescue PG::UndefinedColumn
    connection.exec('ROLLBACK')
  end

  def self.select_all_tests(connection:)
    return unless connection.instance_of?(PG::Connection)

    connection.exec('SELECT * FROM exames;')
  rescue PG::ConnectionBad
    nil
  end

  private_class_method def self.create_insert_sql(row)
    columns = row.keys.map { |key| "\"#{key}\"" }.join(', ')
    values = row.values.map { |value| "'#{value.gsub(/'/, "''")}'" }.join(', ')

    "INSERT INTO exames (#{columns}) VALUES (#{values});"
  end
end
