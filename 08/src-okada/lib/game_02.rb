class Game
    attr_reader :score

    def initialize
        @score = 0
    end

    def roll(pin)
        @score += pin
    end


end