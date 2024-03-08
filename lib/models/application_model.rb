require_relative '../services/database_service'

class ApplicationModel
  def initialize(**attributes)
    @id = attributes[:id]
  end

  def self.create(connection: nil, end_connection: true, **attributes)
    connection ||= DatabaseService.connect
    instance = new(**attributes)

    sql, values = instance.generate_insert_sql
    instance.id = connection.exec_params(sql, values).first['id'].to_i

    connection.exec('COMMIT') unless connection.transaction_status.zero?
    connection.close if end_connection
    instance
  rescue PG::UniqueViolation, PG::NotNullViolation, PG::ForeignKeyViolation
    nil
  end

  def self.find(id:, connection: nil, end_connection: true)
    connection ||= DatabaseService.connect
    sql = "SELECT * FROM #{table_name} WHERE id = $1;"
    result = connection.exec_params(sql, [id])
    connection.close if end_connection

    return_first_result(result)
  end

  def self.find_by(connection: nil, **args)
    return nil if args.empty?

    connection ||= DatabaseService.connect
    query = args.map { |column, value| "#{column} = '#{value}'" }.join(' AND ')
    result = connection.exec("SELECT * FROM #{table_name} WHERE #{query}")
    connection.close

    return_first_result(result)
  rescue PG::UndefinedColumn
    nil
  end

  def generate_insert_sql
    ["INSERT INTO #{table_name} (#{columns}) VALUES (#{values_map}) RETURNING id", values]
  end

  private

  private_class_method def self.return_first_result(result)
    return nil if result.count.zero?

    data = result.first.each_with_object({}) do |(key, value), hash|
      value = key.end_with?('id') ? value.to_i : value
      key = key.to_sym
      hash[key] = value
    end

    new(**data)
  end

  def table_name
    "#{self.class.name.downcase}s"
  end

  private_class_method def self.table_name
    "#{name.downcase}s"
  end

  def columns
    instance_variables[1..].join(', ').delete('@')
  end

  def values_map
    values_map = instance_variables[1..].map.with_index do |_, index|
      "$#{index + 1}"
    end

    values_map.join(', ')
  end

  def values
    instance_variables[1..].map do |column|
      instance_variable_get(column)
    end
  end
end
