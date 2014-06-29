require 'csv'
require 'pry'

class String  # オープンクラス! 谷口の発表で(多分)出てきます。
  def to_b
    if self == 'false'
      false
    else
      true
    end
  end
end

module TypedCsv
  CONVERTER_TO_JSON_TYPE_MAP = {
    'string' => :to_s,
    'number' => :to_f,
    'integer' => :to_i,
    'boolean' => :to_b
  }

  module_function

  def type_of_col(col_name, json_schema)
    begin
      return json_schema[:items][:properties][col_name.to_sym][:type]
    rescue NoMethodError
      'string'
    end
  end

  def required_cols(json_schema)
    begin
      return json_schema[:items][:required] || []
    rescue NoMethodError
      return []
    end
  end

  def convert_csv_values(csv_str, json_schema)
    csv = CSV.parse(csv_str, col_sep: ',')
    headers = csv.shift
    csv.map do |row|
      row.each_with_index.each_with_object({}) do |(col, i), row_obj|
        col_name = headers[i]
        type = type_of_col(col_name, json_schema)
        converter = CONVERTER_TO_JSON_TYPE_MAP[type]
        if col
          typed_col = col.send converter
        else
          if required_cols(json_schema).include? col_name
            raise message: "#{colname} is required!"
          end
          typed_col = nil
        end
        row_obj[col_name.to_sym] = typed_col
      end
    end
  end
end
