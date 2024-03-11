require 'csv'
require_relative '../../lib/services/database_service'
require_relative '../../lib/models/patient_model'
require_relative '../../lib/models/doctor_model'
require_relative '../../lib/models/examination_model'
require_relative '../../lib/models/test_model'

module ImportCSVService
  def self.run(file_path:, connection: nil)
    connection ||= DatabaseService.connect
    data = read_file(file_path:)
    connection.transaction do |conn|
      data.each do |row|
        insert_row_into_database(row:, connection: conn, end_connection: false)
      end
    end
  end

  private_class_method def self.insert_row_into_database(row:, connection:, end_connection:)
    patient = find_or_create_patient(row:, connection:, end_connection:)
    doctor = find_or_create_doctor(row:, connection:, end_connection:)
    examination = find_or_create_examination(row:, connection:, end_connection:, patient:, doctor:)
    create_test(row:, connection:, end_connection:, examination:)
  end

  private_class_method def self.find_or_create_patient(row:, connection:, end_connection:)
    cpf, full_name, email, birth_date, address, city, state = row.shift(7)
    patient = Patient.find_by(cpf:, connection:, end_connection:)
    patient || Patient.create(cpf:, full_name:, birth_date:, email:, address:, city:, state:, connection:,
                              end_connection:)
  end

  private_class_method def self.find_or_create_doctor(row:, connection:, end_connection:)
    crm, crm_state, full_name, email = row.shift(4)
    doctor = Doctor.find_by(crm:, connection:, end_connection:)
    doctor || Doctor.create(crm:, full_name:, email:, crm_state:, connection:, end_connection:)
  end

  private_class_method def self.find_or_create_examination(row:, connection:, end_connection:, patient:, doctor:)
    result_token, date = row.shift(2)
    examination = Examination.find_by(result_token:, connection:, end_connection:)
    examination || Examination.create(result_token:, patient_id: patient.id, doctor_id: doctor.id, date:,
                                      connection:, end_connection:)
  end

  private_class_method def self.create_test(row:, connection:, end_connection:, examination:)
    type, limits, results = row
    Test.create(examination_id: examination.id, type:, limits:, results:, connection:, end_connection:)
  end

  private_class_method def self.read_file(file_path:)
    data = CSV.read(file_path, headers: true, col_sep: ';').to_a
    data.shift
    data
  end
end
