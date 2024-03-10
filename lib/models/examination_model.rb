require_relative 'application_model'

class Examination < ApplicationModel
  ALL_EXAMS_SQL = 'SELECT e.id, e.result_token, e.date, p.cpf, p.full_name, p.email, p.birth_date, d.crm, d.crm_state,
  d.full_name as doctor_name
  FROM examinations e
  JOIN patients p ON e.patient_id = p.id
  JOIN doctors d ON e.doctor_id = d.id'.freeze

  attr_accessor :id, :patient_id, :doctor_id, :result_token, :date

  def initialize(**attributes)
    super

    @patient_id = attributes[:patient_id]
    @doctor_id = attributes[:doctor_id]
    @result_token = attributes[:result_token]
    @date = attributes[:date]
  end

  def self.all_to_json(connection: nil, end_connection: true)
    connection ||= DatabaseService.connect

    examinations = connection.exec(ALL_EXAMS_SQL).to_a
    results = examinations.each_with_object([]) do |examination, array|
      exam_id = examination['id'].to_i
      tests_array = connection.exec("SELECT type, limits, results FROM tests WHERE examination_id = #{exam_id}").to_a
      array << format_examination_json(examination:, tests_array:)
    end
    connection.close if end_connection
    results
  end

  private_class_method def self.format_examination_json(examination:, tests_array:)
    {
      result_token: examination['result_token'],
      date: examination['date'],
      full_name: examination['full_name'],
      cpf: examination['cpf'],
      email: examination['email'],
      birth_date: examination['birth_date'],
      doctor: { crm: examination['crm'], crm_state: examination['crm_state'], full_name: examination['doctor_name'] },
      tests: tests_array.map { |test| test.transform_keys(&:to_sym) }
    }
  end

  private_class_method def self.generate_exams_sql; end
end
