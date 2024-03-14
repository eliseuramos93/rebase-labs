require_relative 'application_model'

class Examination < ApplicationModel
  attr_accessor :id, :patient_id, :doctor_id, :result_token, :date

  def initialize(**attributes)
    super

    @patient_id = attributes[:patient_id]
    @doctor_id = attributes[:doctor_id]
    @result_token = attributes[:result_token]
    @date = attributes[:date]
  end

  def self.select_all_to_json(connection: nil, end_connection: true)
    connection ||= DatabaseService.connect

    examinations = connection.exec(ALL_EXAMS_SQL).to_a
    results = examinations.each_with_object([]) do |examination, array|
      array << create_examination_hash(examination:, connection:)
    end
    connection.close if end_connection
    results
  rescue PG::ConnectionBad
    connection_bad_warning
  end

  def self.select_to_json(connection: nil, end_connection: true, result_token:)
    connection ||= DatabaseService.connect

    examination = connection.exec("#{FIND_EXAM_BY_TOKEN} '#{result_token}'").first
    return examination_not_found unless examination

    result = create_examination_hash(examination:, connection:)
    connection.close if end_connection
    result
  rescue PG::ConnectionBad
    connection_bad_warning
  end

  private_class_method def self.create_examination_hash(examination:, connection:)
    exam_id = examination['id'].to_i
    tests_array = select_distinct_tests_from_exam_id(connection:, exam_id:)

    { result_token: examination['result_token'],
      date: examination['date'],
      full_name: examination['full_name'],
      cpf: examination['cpf'],
      email: examination['email'],
      birth_date: examination['birth_date'],
      doctor: { crm: examination['crm'], crm_state: examination['crm_state'], full_name: examination['doctor_name'] },
      tests: tests_array.map { |test| test.transform_keys(&:to_sym) } }
  end

  private_class_method def self.connection_bad_warning
    { errors: { message: 'Não foi possível conectar-se ao banco de dados.' } }
  end

  private_class_method def self.examination_not_found
    { errors: { message: 'Não foi encontrado nenhum exame com o token informado.' } }
  end

  private_class_method def self.select_distinct_tests_from_exam_id(connection:, exam_id:)
    connection.exec("SELECT DISTINCT ON (type) type, limits, results FROM tests WHERE examination_id = #{exam_id}").to_a
  end
end
