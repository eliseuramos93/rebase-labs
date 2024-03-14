require_relative 'application_model'

class Patient < ApplicationModel
  attr_accessor :id, :cpf, :full_name, :email, :birth_date, :address, :city, :state

  def initialize(**attributes)
    super

    @cpf = attributes[:cpf]
    @full_name = attributes[:full_name]
    @email = attributes[:email]
    @birth_date = attributes[:birth_date]
    @address = attributes[:address]
    @city = attributes[:city]
    @state = attributes[:state]
  end
end
