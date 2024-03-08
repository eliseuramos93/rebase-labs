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
end
