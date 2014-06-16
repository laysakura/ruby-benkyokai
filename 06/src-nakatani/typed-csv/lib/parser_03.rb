require 'csv'

module TypedCsv
  module_function

  def convert_csv_values(csv_str)
    CSV.parse(csv_str, col_sep: ',')
  end
end
