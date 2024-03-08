require 'spec_helper'
require_relative '../../lib/models/lab_analysis_model'
require_relative '../../lib/models/patient_model'
require_relative '../../lib/models/doctor_model'

RSpec.describe LabAnalysis do
  context 'quando inicializado' do
    it 'armazena as informações corretas no objeto' do
      patient = Patient.new(id: 13, cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                            birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.new(id: 27, crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                          email: 'wewereonabreak@gmail.com')
      lab_analysis = LabAnalysis.new(patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                     date: '2023-10-31')

      expect(lab_analysis.patient_id).to eq 13
      expect(lab_analysis.doctor_id).to eq 27
      expect(lab_analysis.result_token).to eq 'SCCP10'
      expect(lab_analysis.date).to eq '2023-10-31'
    end
  end
end
