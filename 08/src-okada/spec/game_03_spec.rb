require 'game_03.rb'

# game_02.rbをrequireした場合
# .F

# Failures:

#   1) A bowling score calculator should score 150 for an all fives game
#      Failure/Error: expect(@game.score).to eq 150
       
#        expected: 150
#             got: 105
       
#        (compared using ==)
#      # ./spec/game_03_spec.rb:15:in `block (2 levels) in <top (required)>'

# Finished in 0.00277 seconds (files took 0.43345 seconds to load)
# 2 examples, 1 failure

# Failed examples:

# rspec ./spec/game_03_spec.rb:13 # A bowling score calculator should score 150 for an all fives game


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

end