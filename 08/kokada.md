# Kataを学んで巨人の肩の上に乗ろう
Coding Kataの紹介とRubyで頑張った感想

## 参考URL
- codekata.com http://codekata.com/kata/codekata-intro/
- 日本語で紹介されているスライド https://speakerdeck.com/hakobe/tddfalselian-xi-coding-kata-falseshi-jian
- 今回参考にしたテストコード http://butunclebob.com/ArticleS.DavidChelimsky.BowlingWithRspec 

## Code Kata とは

- ソフトウェア開発の練習法
- 空手の型のように短い時間(30分から1時間程度)でこなせるプログラミングの課題


## 実践
### ステップ1


`spec/game_01_spec.rb`

```ruby
require 'game_01.rb'

context 'A bowling score calculator' do

end
```


`lib/game_01.rb`

```ruby
class Game
end
```

この段階ではまだテストケースを書いてないので何も起こりません
`rspec spec/game_01_spec.rb  `

```ruby
No examples found.


Finished in 0.00034 seconds (files took 0.29559 seconds to load)
0 examples, 0 failures
```

### ステップ2
いよいよテストを書いてみます

`spec/game_02_spec.rb`

```ruby
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
```

では、このテストが通るようにとりあえずコードを書いてみます

`lib/game_02.rb`

```ruby
class Game
    attr_reader :score

    def initialize
        @score = 0
    end

    def roll(pin)
        @score += pin
    end


end
```

`rspec spec/game_02_spec.rb`

```
.

Finished in 0.003 seconds (files took 0.28286 seconds to load)
1 example, 0 failures

```

めでたくテストが通りました(大変めでたい)


### ステップ3
現状では倒れたピンの本数がそのままスコアになるため、次のテストではスペアへ対応できるかチェックします

`spec/game_03_spec.rb`

```ruby
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
```

`lib/game_03.rb`

```ruby
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

        if (frame_finished?)
            update_status
            @frame[:score] = @frame[:throws].inject(:+)# block or symbol of method name
            @frames.push(@frame)
            @frame = init_frame
        end
    end

    def update_status
        if (is_Spair?)
            @frame[:status] = Spair
        else
            @last_status = 0
        end
    end

    def is_Spair?
        return (@frame[:throws].length == 2 && @frame[:throws].inject(:+) == 10)
    end

    def frame_finished?
        if (@frames.length == 9) # is last frame
            return (@frame[:throws].length == 3)
        else
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
```

とりあえずテストは通りそうなのでこの段階で実行してみます

```
..

Finished in 0.00424 seconds (files took 0.3644 seconds to load)
2 examples, 0 failures
```

無事通りました。
本来はここでリファクタリングをしてから次に進みますが、諸般の事情で修正する時間がないため次に進みます

### ステップ4(最終)
`spec/game_04_spec.rb`

```ruby
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
```

```ruby
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
```

何はともあれ、テストを走らせてみましょう

` rspec spec/game_04_spec.rb`

```
...

Finished in 0.00306 seconds (files took 0.29264 seconds to load)
3 examples, 0 failures
```

通りました。最終フレームに関する挙動が怪しいですがひとまずテストは通ったので、ここで一段落にします

### 現在のコードの問題点
- リファクタリングがされていない(大変見にくい)
- 正常系のテストしか走っていない。最終フレームの処理を確認されたら落ちる

### 次に練習する時のための反省
- 事前によくボーリングのルールを把握してから挑むべきだった
- フレームをクラスとして分けた方が良いかも