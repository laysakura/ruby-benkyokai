require 'game_02.rb'

# game_01.rbをrequireした場合
# F

# Failures:

#   1) A bowling score calculator should score 0 for an all gutter game
#      Failure/Error: (1..20).each { @game.roll(0) }
#      NoMethodError:
#        undefined method `roll' for #<Game:0x007fac708a5128>
#      # ./spec/game_02_spec.rb:9:in `block (3 levels) in <top (required)>'
#      # ./spec/game_02_spec.rb:9:in `each'
#      # ./spec/game_02_spec.rb:9:in `block (2 levels) in <top (required)>'

# Finished in 0.00057 seconds (files took 0.3402 seconds to load)
# 1 example, 1 failure

# Failed examples:

# rspec ./spec/game_02_spec.rb:8 # A bowling score calculator should score 0 for an all gutter game


context 'A bowling score calculator' do
    before do
        @game = Game.new
    end

    it 'should score 0 for an all gutter game' do
        (1..20).each { @game.roll(0) }
        expect(@game.score).to eq 0
    end


end