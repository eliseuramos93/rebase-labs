require 'csv'

class CSVConversionStrategy
  def self.convert(file_path)
    raise NotImplementedError, 'Conversion logic must be implemented on subclasses'
  end
end

class CSVToJsonStrategy < CSVConversionStrategy
  def self.convert(file_path)
    rows = CSV.read(file_path, col_sep: ';')

    columns = rows.shift

    rows.map do |row|
      row.each_with_object({}).with_index do |(cell, acc), idx|
        column = columns[idx]
        acc[column] = cell
      end
    end.to_json
  end
end

class CSVConverter
  def initialize(strategy)
    @strategy = strategy
  end

  def convert(file_path)
    @strategy.convert(file_path)
  end
end
