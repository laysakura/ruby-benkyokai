require 'pry'
require 'markaby'

mab = Markaby::Builder.new
mab.html do
binding.pry
  head { title "Boats.com" }
  body do
    h1 "Boats.com has great deals"
    ul do
      li "$49 for a canoe"
      li "$39 for a raft"
      li "$29 for a huge boot that floats and can fit 5 people"
    end
  end
end
puts mab.to_s
