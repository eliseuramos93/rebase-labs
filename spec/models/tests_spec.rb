require 'spec_helper'
require_relative '../../lib/models/test_model'

RSpec.describe LabAnalysis do
  context 'quando inicializado' do
    it 'armazena as informações corretas no objeto' do
      patient = Patient.new(id: 13, cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                            birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')
      doctor = Doctor.new(id: 27, crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                          email: 'wewereonabreak@gmail.com')
      lab_analysis = LabAnalysis.new(id: 93, patient_id: patient.id, doctor_id: doctor.id, result_token: 'SCCP10',
                                     date: '2023-10-31')
      test = Test.new(patient_id: patient.id, doctor_id: doctor.id, lab_analysis_id: lab_analysis.id, type: 'Hemácias',
                      limits: '45-52', results: '97')

      expect(test.patient_id).to eq 13
      expect(test.doctor_id).to eq 27
      expect(test.lab_analysis_id).to eq 93
      expect(test.type).to eq 'Hemácias'
      expect(test.limits).to eq '45-52'
      expect(test.results).to eq '97'
    end
  end
end
