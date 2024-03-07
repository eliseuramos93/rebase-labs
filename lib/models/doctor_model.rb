class Doctor
  attr_accessor :id, :crm, :crm_state, :full_name, :email

  def initialize(id: nil, crm:, crm_state:, full_name:, email:)
    @id = id
    @crm = crm
    @crm_state = crm_state
    @full_name = full_name
    @email = email
  end
end
