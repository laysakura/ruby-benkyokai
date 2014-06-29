require 'csv'
require 'pry'


def catch_to_x_n(name, &positive) #to_s_n, to_f_nなど
  regex = /^(to_[sfib])_n$/
  if res = regex.match(name)
    return positive.call(res[1])
  else
    raise NoMethodError
  end
end

class String  # オープンクラス! 谷口の発表で(多分)出てきます。
  def to_b
    if self == 'false'
      false
    else
      true
    end
  end

  def method_missing(name, *args)
    catch_to_x_n(name) { |method| self.send method}
  end
end

class NilClass
  def method_missing(name, *args)
    catch_to_x_n(name) {|tmp| nil}
  end
end

module TypedCsv

  CONVERTER_TO_JSON_TYPE_MAP = {
    'string' => :to_s_n, # to_string_or_nil
    'number' => :to_f_n,
    'integer' => :to_i_n,
    'boolean' => :to_b_n,
  }

  module_function

  def type_of_col(col_name, json_schema)
    begin
      return json_schema[:items][:properties][col_name.to_sym][:type]
    rescue NoMethodError
      'string'
    end
  end

  def is_required(col_name, json_schema)
    begin
      if json_schema[:items][:required].count(col_name) > 0
        return true
      end
    rescue NoMethodError
      #そもそもrequiredが設定されていない時は何もしない
    end
    false
  end

  def convert_csv_values(csv_str, json_schema)
    csv = CSV.parse(csv_str, col_sep: ',')

    headers = csv.shift
    csv.map do |row|
      row.each_with_index.each_with_object({}) do |(col, i), row_obj|
        col_name = headers[i]
        type = type_of_col(col_name, json_schema)
        if is_required(col_name, json_schema) and col == nil #requiredかつ空白の場合は例外
          raise TypeError, "#{col_name} is required"
        end
        converter = CONVERTER_TO_JSON_TYPE_MAP[type]
        typed_col = col.send converter  # 動的なメソッド呼び出し。メタプログラミングで詳しく扱います。
        row_obj[col_name.to_sym] = typed_col
      end
    end
  end
end

