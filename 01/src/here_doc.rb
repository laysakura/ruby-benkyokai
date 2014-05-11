puts "-- Here document --"
puts <<EOS
Hello\tworld!
#{1 + 1}
EOS

puts "-- Single-quoted here document --"
puts <<'EOS'
Hello\tworld!
#{1 + 1}
EOS
