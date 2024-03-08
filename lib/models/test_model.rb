require_relative 'application_model'

class Test < ApplicationModel
  attr_accessor :id, :examination_id, :type, :limits, :results

  def initialize(**attributes)
    super

    @examination_id = attributes[:examination_id]
    @type = attributes[:type]
    @limits = attributes[:limits]
    @results = attributes[:results]
  end
end
