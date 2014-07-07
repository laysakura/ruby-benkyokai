require 'game_04.rb'

# ..F

# Failures:

#   1) A bowling score calculator should score 300 for a perfect game
#      Failure/Error: expect(@game.score).to eq 300
       
#        expected: 300
#             got: 120
       
#        (compared using ==)
#      # ./spec/game_04_spec.rb:42:in `block (2 levels) in <top (required)>'

# Finished in 0.00125 seconds (files took 0.13876 seconds to load)
# 3 examples, 1 failure

# Failed examples:

# rspec ./spec/game_04_spec.rb:40 # A bowling score calculator should score 300 for a perfect game


context 'A bowling score calculator' do
    before do
        @game = Game.new
    end

    it 'should score 0 for an all gutter game' do
        (1..20).each { @game.roll(0) }
        expect(@game.score).to eq 0
    end

    it "should score 150 for an all fives game" do
        (1..21).each { @game.roll(5) }
        expect(@game.score).to eq 150
    end

    it  "should score 300 for a perfect game" do
        (1..12).each { @game.roll(10) }
         expect(@game.score).to eq 300
    end

end

