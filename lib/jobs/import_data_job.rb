require 'sidekiq'

class ImportDataJob
  include Sidekiq::Job

  def perform
    sleep 5
    puts 'Oi, o Sidekiq terminou o job. :)'
  end
end
