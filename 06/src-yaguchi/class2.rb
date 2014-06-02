class MockTime
  def self.now
    Time.new("2014-06-03 00:04:04 +0900")
  end
end

conf = { debug: true }

TimeClass = conf[:debug] ? MockTime : Time

puts TimeClass.now
