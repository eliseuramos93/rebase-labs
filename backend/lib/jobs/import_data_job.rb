require 'sidekiq'
require_relative '../services/import_csv_service'

class ImportDataJob
  include Sidekiq::Job

  def perform(data)
    ImportCSVService.run(data:)
  end
end
