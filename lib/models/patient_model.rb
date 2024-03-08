class Patient
  attr_accessor :id, :cpf, :full_name, :email, :birth_date, :address, :city, :state

  def initialize(id: nil, cpf:, full_name:, email:, birth_date:, address:, city:, state:)
    @id = id
    @cpf = cpf
    @full_name = full_name
    @email = email
    @birth_date = birth_date
    @address = address
    @city = city
    @state = state
  end

  def self.create(cpf:, full_name:, email:, birth_date:, address:, city:, state:, connection: nil, end_connection: true)
    connection ||= DatabaseService.connect
    patient = Patient.new(cpf:, full_name:, email:, birth_date:, address:, city:, state:)

    sql, values = patient.generate_insert_sql
    patient.id = connection.exec_params(sql, values).first['id'].to_i

    connection.exec('COMMIT') unless connection.transaction_status.zero?
    connection.close if end_connection
    patient
  rescue PG::UniqueViolation, PG::NotNullViolation
    nil
  end

  def self.find(id:, connection:, end_connection:)
    sql = 'SELECT * FROM patients WHERE id = $1;'
    results = connection.exec_params(sql, [id])
    connection.close if end_connection

    return nil if results.ntuples.zero?

    data = results.first
    Patient.new(cpf: data['cpf'], full_name: data['full_name'], email: data['email'], birth_date: data['birth_date'],
                address: data['address'], city: data['city'], state: data['state'], id: data['id'].to_i)
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
end
