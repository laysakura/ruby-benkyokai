require './mysql_benchmark_report.rb'

host = 'localhost'
username = 'root'
password = ''
dbname = 'rakumeshi'

mbr = MysqlBenchmarkReport.new(:host => host, :username => username, :password => password, :database => dbname)

 open('./benchmark.sql') do |f|
     f.each do |line|
         line.chomp
         mbr.report(line)
     end
 end
