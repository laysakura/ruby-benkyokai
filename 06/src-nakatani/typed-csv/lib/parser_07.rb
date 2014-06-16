require 'csv'

module TypedCsv
  module_function

  def convert_csv_values(csv_str)
    csv = CSV.parse(csv_str, col_sep: ',')

    headers = csv.shift
    csv.map do |row|
      row.each_with_index.each_with_object({}) do |(col, i), row_obj|
        col_name = headers[i]
        row_obj[col_name.to_sym] = col
      end
    end
  end
end
