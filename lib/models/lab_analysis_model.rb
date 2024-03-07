class LabAnalysis
  attr_accessor :id, :patient_id, :doctor_id, :result_token, :date

  def initialize(id: nil, patient_id:, doctor_id:, result_token:, date:)
    @id = id
    @patient_id = patient_id
    @doctor_id = doctor_id
    @result_token = result_token
    @date = date
  end
end
