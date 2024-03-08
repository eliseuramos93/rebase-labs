class Doctor
  attr_accessor :id, :crm, :crm_state, :full_name, :email

  def initialize(id: nil, crm:, crm_state:, full_name:, email:)
    @id = id
    @crm = crm
    @crm_state = crm_state
    @full_name = full_name
    @email = email
  end

  def self.create(crm:, crm_state:, full_name:, email:, connection: nil, end_connection: true)
    connection ||= DatabaseService.connect
    doctor = Doctor.new(crm:, crm_state:, full_name:, email:)

    sql, values = doctor.generate_insert_sql
    doctor.id = connection.exec_params(sql, values).first['id'].to_i

    connection.exec('COMMIT') unless connection.transaction_status.zero?
    connection.close if end_connection
    doctor
  rescue PG::UniqueViolation, PG::NotNullViolation
    nil
  end

  def self.find(id:, connection:, end_connection:)
    sql = 'SELECT * FROM doctors WHERE id = $1;'
    results = connection.exec_params(sql, [id])
    connection.close if end_connection

    return nil if results.ntuples.zero?

    data = results.first
    Doctor.new(crm: data['crm'], crm_state: data['crm_state'], full_name: data['full_name'], email: data['email'],
               id: data['id'].to_i)
  end

  def self.find_by(options = {})
    return nil if options.empty?

    connection = options.delete(:connection) || DatabaseService.connect
    query = options.map { |column, value| "#{column} = '#{value}'" }.join(' AND ')
    result = connection.exec("SELECT * FROM doctors WHERE #{query}")
    connection.close

    return nil if result.count.zero?

    new(**symbolize_keys(result.first))
  rescue PG::UndefinedColumn
    nil
  end

  def generate_insert_sql
    ["INSERT INTO #{table_name} (#{columns}) VALUES (#{values_map}) RETURNING id", values]
  end

  private

  def table_name
    "#{self.class.name.downcase}s"
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

  private_class_method def self.symbolize_keys(result_hash)
    result_hash.transform_keys(&:to_sym)
  end
end
