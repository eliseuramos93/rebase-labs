require 'benchmark'
require 'csv'
require_relative '../../lib/services/database_service'
require_relative '../../lib/models/patient_model'
require_relative '../../lib/models/doctor_model'
require_relative '../../lib/models/examination_model'
require_relative '../../lib/models/test_model'

pg_conn = DatabaseService.connect
performance = Benchmark.measure do
  pg_conn.transaction do |connection|
    end_connection = false
    file_path = File.join(Dir.pwd, 'config', 'initializers', 'data.csv')
    data = CSV.read(file_path, headers: true, col_sep: ';').to_a
    data.shift

    data.each_with_index do |row, index|
      cpf, full_name, email, birth_date, address, city, state = row[0..6]
      patient = Patient.find_by(cpf:, connection:, end_connection:)
      patient ||= Patient.create(cpf:, full_name:, birth_date:, email:, address:, city:, state:, connection:,
                                 end_connection:)

      crm, crm_state, full_name, email = row[7..10]
      doctor = Doctor.find_by(crm:, connection:, end_connection:)
      doctor ||= Doctor.create(crm:, full_name:, email:, crm_state:, connection:, end_connection:)

      result_token, date = row[11..12]
      examination = Examination.find_by(result_token:, connection:, end_connection:)
      examination ||= Examination.create(result_token:, patient_id: patient.id, doctor_id: doctor.id, date:,
                                         connection:, end_connection:)

      type, limits, results = row[13..15]
      Test.create(examination_id: examination.id, type:, limits:, results:, connection:, end_connection:)
    end
  end
end

p "Tempo de execução: #{performance.real} segundos."

pg_conn.close if pg_conn
