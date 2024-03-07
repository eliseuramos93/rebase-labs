require 'spec_helper'
require_relative '../../lib/models/patient_model'

RSpec.describe Patient do
  context 'quando inicializado' do
    it 'armazena as informações corretas no objeto' do
      patient = Patient.new(cpf: '283.368.670-66', full_name: 'Reginaldo Rossi', email: 'reidobrega@gmail.com',
                            birth_date: '1944-02-14', address: '200 Rua do Garçom', city: 'Recife', state: 'PE')

      expect(patient.cpf).to eq '283.368.670-66'
      expect(patient.full_name).to eq 'Reginaldo Rossi'
      expect(patient.email).to eq 'reidobrega@gmail.com'
      expect(patient.birth_date).to eq '1944-02-14'
      expect(patient.address).to eq '200 Rua do Garçom'
      expect(patient.city).to eq 'Recife'
      expect(patient.state).to eq 'PE'
    end
  end
end
