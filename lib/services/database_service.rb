require_relative '../strategies/csv_conversion_strategy'

class DatabaseService
  def self.insert_data(file_path:, connection:)
    converter = CSVConverter.new(CSVToJsonStrategy)
    json_data = JSON.parse(converter.convert(file_path))

    json_data.each do |row|
      connection.exec(create_insert_sql(row))
    end

  rescue PG::UndefinedColumn
    return connection.exec('ROLLBACK')
  end

  private_class_method def self.create_insert_sql(row)
    columns = row.keys.map { |key| "\"#{key}\"" }.join(', ')
    values = row.values.map { |value| "'#{value}'" }.join(', ')

    "INSERT INTO exames (#{columns}) VALUES (#{values});"
  end
end
