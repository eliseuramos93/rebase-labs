class Patient
  attr_accessor :id, :cpf, :full_name, :email, :birth_date, :address, :city, :state

  def initialize(id: nil, cpf:, full_name:, email:, birth_date:, address:, city:, state:)
    @id = id
    @cpf = cpf
    @full_name = full_name
    @email = email
    @birth_date = birth_date
    @address = address
    @city = city
    @state = state
  end
end
