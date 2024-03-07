require 'spec_helper'
require_relative '../../lib/models/doctor_model'

RSpec.describe Doctor do
  context 'quando inicializado' do
    it 'armazena as informações corretas no objeto' do
      doctor = Doctor.new(crm: 'B000BJ20J4', crm_state: 'PI', full_name: 'Dr. Ross Geller',
                          email: 'wewereonabreak@gmail.com')

      expect(doctor.crm).to eq 'B000BJ20J4'
      expect(doctor.crm_state).to eq 'PI'
      expect(doctor.full_name).to eq 'Dr. Ross Geller'
      expect(doctor.email).to eq 'wewereonabreak@gmail.com'
    end
  end
end
