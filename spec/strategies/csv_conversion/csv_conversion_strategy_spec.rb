require 'spec_helper'
require_relative '../../../lib/strategies/csv_conversion_strategy'

RSpec.describe CSVConversionStrategy do
  context '#convert' do
    it 'apenas realiza conversão de estratégias implementadas' do
      file_path = File.join(__dir__, 'spec', 'support', 'assets', 'test_data.csv')

      expect { CSVConversionStrategy.convert(file_path) }.to raise_error(an_instance_of(NotImplementedError)
        .and(having_attributes(message: 'Conversion logic must be implemented on subclasses')))
    end
  end
end
