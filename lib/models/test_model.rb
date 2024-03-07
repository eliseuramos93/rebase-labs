class Test
  attr_accessor :id, :patient_id, :doctor_id, :lab_analysis_id, :type, :limits, :results

  def initialize(id: nil, patient_id:, doctor_id:, lab_analysis_id:, type:, limits:, results:)
    @id = id
    @patient_id = patient_id
    @doctor_id = doctor_id
    @lab_analysis_id = lab_analysis_id
    @type = type
    @limits = limits
    @results = results
  end
end
