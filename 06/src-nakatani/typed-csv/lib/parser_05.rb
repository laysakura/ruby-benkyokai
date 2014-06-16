require 'csv'
require 'pry'

module TypedCsv
  module_function

  def convert_csv_values(csv_str)
    csv = CSV.parse(csv_str, col_sep: ',')

    binding.pry  # ブレークポイント

    headers = csv.shift
    csv.map do |row|
      row_obj = {}
      row.each_with_index do |col, i|
        col_name = headers[i]
        row_obj[col_name.to_sym] = col
      end
    end
  end
end
