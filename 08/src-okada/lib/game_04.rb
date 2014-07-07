class Game

    def score
        calc_score
    end

    Spair = 1
    Strike = 2

    def initialize
        @score = 0
        @frames = []
        @frame = init_frame
    end

    def roll(pin)
        @frame[:throws].push(pin)
        update_frame(pin)
    end

    def update_frame(pin)

        update_status
        if (frame_finished?)
            @frame[:score] = @frame[:throws].inject(:+)# block or symbol of method name
            @frames.push(@frame)
            @frame = init_frame
        end
    end

    def update_status
        if (is_Spair?)
            @frame[:status] = Spair
        elsif(is_Strike?)
            @frame[:status] = Strike
        else
            @frame[:status] = 0
        end
    end

    def is_Spair?
        return (@frame[:throws].length == 2 && @frame[:throws].inject(:+) == 10)
    end

    def is_Strike?
        return (@frame[:throws].length == 1 && @frame[:throws].inject(:+) == 10)
    end

    def frame_finished?
        if (@frames.length == 9) # is last frame
            return (@frame[:throws].length == 3)
        else
            if (@frame[:status] != 0)
                return true
            end
            return (@frame[:throws].length == 2)
        end
    end

    def calc_score
        res = 0
        @frames.each_with_index{|frame, i|
            case frame[:status]
            when Spair
                throws = get_throws_from_frame_index(i + 1)
                frame[:score] = 10 + throws[0]
            when Strike
                throws = get_throws_from_frame_index(i + 1)
                frame[:score] = 10 + throws[0..1].inject(:+)
            end
            res += frame[:score]
        }
        res
    end

    def init_frame
        {:score => 0, :throws => [], :status => 0}
    end

    def get_throws_from_frame_index(frame_from)
        throws = []
        @frames[frame_from..-1].each{|frame| 
            throws.concat(frame[:throws])
        }
        if throws.length == 0
            throws = [0]
        end
        throws
    end

end
