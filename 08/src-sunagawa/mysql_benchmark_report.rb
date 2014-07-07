require 'mysql2'
require 'benchmark'

class MysqlBenchmarkReport
    
    def initialize (params)
        @client = Mysql2::Client.new(params)
    end

    def report (stmt) 
        explain = execute_explain(stmt)

        puts "## SQL\n```sql\n #{stmt}\n```"
        puts ""
        execute_benchmark(stmt)
        puts ""
        print_explain(explain)
    end
    
    def execute_benchmark (stmt)
        label = <<EOS
| user       | system     | total      | real         |
| ----------:| ----------:| ----------:| ------------:|
EOS
        format = "| %4.8u | %4.8y | %4.8t | %4.8r |\n"

        puts "### Benchmark"
        Benchmark.benchmark(label, -1, format) do |x|
            x.report { @client.query(stmt) }
        end
        #=> Benchmark::benchmark(最初の行出力, "ラベル幅", 出力フォーマット") ラベル幅は、デフォルトで半角スペースが入っているのでそれを取り除くため-1
    end

    def print_explain (explain)
        columns = %w(id --- select_type table type possible_keys key key_len ref rows Extra)

        column_name_max_length = 13
        lines = columns.map.with_index do |column, index|
            space = index == 1 ? '-' : ' '
            '|' + column +  space * (column_name_max_length - column.length)
        end
            
        explain.each do |row|
            value_max_length = 4
            row.each {|k, v| row[k] = v.to_s; value_max_length = v.to_s.length if value_max_length < v.to_s.length} # => 出力揃えるため、一番長い文字列の長さを取る。また数字のままだと不便だったのでto_sしている

            # 出力の整形　標準出力でも見やすいように、短いものはスペースで埋めて揃える
            lines.map!.with_index do |line, index|
                space = ' '
                value = row[columns[index]].to_s
                if index == 1
                    space = '-'
                    line + '|:' +  value + space * (value_max_length - value.to_s.length - 1)
                else
                    line + '|' +  value + space * (value_max_length - value.to_s.length)
                end
            end
        end
        puts "### EXPLAIN"
        lines.each { |line| puts line + '|' }
    end

    def execute_explain (stmt)
        explain = []
        @client.query("explain #{stmt}").each do |row|
            explain.push row
        end
    end
    private :print_explain, :execute_explain, :execute_benchmark
end
