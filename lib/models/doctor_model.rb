require_relative 'application_model'

class Doctor < ApplicationModel
  attr_accessor :id, :crm, :crm_state, :full_name, :email

  def initialize(**attributes)
    super

    @crm = attributes[:crm]
    @crm_state = attributes[:crm_state]
    @full_name = attributes[:full_name]
    @email = attributes[:email]
  end
end
