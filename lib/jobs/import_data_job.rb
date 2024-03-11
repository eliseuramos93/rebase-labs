require 'sidekiq'
require_relative '../services/import_csv_service'

class ImportDataJob
  include Sidekiq::Job

  def perform(file_path)
    ImportCSVService.run(file_path:)
  end
end
