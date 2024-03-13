DB_CONFIG = {
  dbname: 'development',
  user: 'postgres',
  password: 'postgres',
  port: '5432',
  host: 'postgres'
}.freeze

TEST_DB_CONFIG = {
  dbname: 'test',
  user: 'postgres',
  password: 'postgres',
  port: '5432',
  host: 'postgres'
}.freeze

ALL_EXAMS_SQL = 'SELECT e.id, e.result_token, e.date, p.cpf, p.full_name, p.email, p.birth_date, d.crm, d.crm_state,
d.full_name as doctor_name
FROM examinations e
JOIN patients p ON e.patient_id = p.id
JOIN doctors d ON e.doctor_id = d.id
ORDER BY e.result_token ASC'.freeze

FIND_EXAM_BY_TOKEN = 'SELECT e.id, e.result_token, e.date, p.cpf, p.full_name, p.email, p.birth_date, d.crm,
d.crm_state, d.full_name as doctor_name
FROM examinations e
JOIN patients p ON e.patient_id = p.id
JOIN doctors d ON e.doctor_id = d.id
WHERE e.result_token ='.freeze

require 'pg'
require 'json'

class DatabaseService
  def self.connect
    config = ENV['APP_ENV'] == 'test' ? TEST_DB_CONFIG : DB_CONFIG
    PG.connect(config)
  end
end
