<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [ネタ出し](#ネタ出し)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# ネタ出し

- ブロック・マニアック
  - ブロックを使って実現される便利機能を述べつつ、その実装をブロックで行う
  - ライブコーディングで each くらい実装する?
    - ソース外部リンクのほうが事故らない
  - 適宜、村上の紹介してた実装を見るやつで本実装と比較してみる

- クラスをより深める
  - コンストラクタ、デストラクタ
  - クラス変数、メソッド
  - 特異メソッド
    - 特異メソッドの解説と用途(深イイポイント)
    - http://blog.livedoor.jp/sasata299/archives/51497378.html

- 単純なクラスベース以外のOOP支援機構
  - mix-in

- モジュール
  - クラスとの共通点
    - メソッド作れたり
  - クラスとの違い
    - インスタンス作れない
  - 実はClassはModuleのサブクラス
    - new, allocate, superclass メソッドが追加されている
    - この辺の話はメタプログラミングの時に





# 宿題 - `Proc.new` と `lambda` の違い、そしてどちらを使うべきか

第2回の加藤くんの発表中にあった質問( https://github.com/laysakura/ruby-benkyokai/issues/6 )の答えを探してきました。

## 結論

- 違い
  - ブロック内の`return`文の挙動
  - 引数の数に関する厳しさ
- どちらを使うべきか
  - `lambda`

## ブロック内の`return`文の挙動の違い

`lambda_proc_return.rb`

```ruby
def lambda_method
  method = lambda { return 10 }
  return 2 * method.call
end

def proc_method
  method = Proc.new { return 10 }
  return 2 * method.call
end


p lambda_method  # => 20
p proc_method    # => 10
```

`lambda`と`Proc.new`で`method`を作り、`method.call`を呼んだ時のそれぞれの挙動:

- `lambda`のときは、ブロック内の`return`の引数が`method.call`の返り値となり、`lambda_method`の処理が継続する。
- `Proc.new`のときは、ブロック内で`return`を呼び出した時点で`proc_method`の処理が終了する。返り値は`Proc.new`のブロック内のもの。

このように、`Proc.new`のブロック内で`return`を呼び出す際には注意が必要です。

(注意: `Proc.new { return 10 }` を `Proc.new { return 10 }` に変更すると、この例では20が出力されるようになります。あくまでも`return`を使った時に注意が必要ということですね。)


## 引数の数に関する厳しさの違い

`lambda_proc_num_args.rb`

```ruby
lambda_method = lambda   { |a, b| p "#{a} #{b}" }
proc_method   = Proc.new { |a, b| p "#{a} #{b}" }


proc_method.call('hello', 'proc')  # => "hello proc"
lambda_method.call('hello', 'lambda')  # => "hello lambda"

proc_method.call('hello', 'Mr.', 'proc')  # => "hello Mr."
#lambda_method.call('hello', 'Mr.', 'lambda')  # => ArgumentError

proc_method.call('proc')  # => "proc "  ## `b`には`nil`が渡っている
#lambda_method.call('lambda')  # => ArgumentError
```

`lambda`で作成された`Proc`インスタンスは、`lambda`のブロックが取るべき引数の個数に厳格です。
`lambda`を使った場合のほうが引数の渡し間違えに気づきやすくなります。

## もう一度結論

**`Proc.new`よりも`lambda`を使ったほうが、意外な挙動・ミスが少ない**

- ブロック内の`return`の挙動
- ブロックが取る引数の個数に対する厳格さ


# ブロック・マニアックス

![実践](../resource/image/practice.png)

ブロックを取るメソッドはとても便利に使えるので、
とても便利に使えるブロックを取るメソッドを自分でも作れるようになろうという趣旨です。

Rubyで標準的に使われるブロックを取るメソッドを紹介し、それと同じような動作をするメソッドを作っていきます。

## ブロック復習

加藤くんの`neatly_open`メソッドの使い方と定義をおさらいしましょう。

https://github.com/laysakura/ruby-benkyokai/blob/master/02/ProcsAndBlocks-kato.md#yield%E3%81%A8%E3%83%96%E3%83%AD%E3%83%83%E3%82%AF%E5%BC%95%E6%95%B0

## ブロックが役に立つ場合

- 繰り返し処理
  - ブロックの中身を繰り返し実行する
- 前処理 => 本質的な処理 => 後処理
  - 本質的な処理をブロックの中身に書き、前処理と後処理はブロックを取るメソッドにやってもらう
  - 例
    - ファイルオープン => ファイル操作 => ファイルクローズ (加藤くんの)
    - DB接続 => DB操作 => DB切断
    - トランザクション開始 => トランザクション中の処理 => トランザクション終了
    - ロック開始 => ロック中の処理 => ロック終了
    - ...

はじめに「前処理 => 本質的な処理 => 後処理」系の例をもういくつか見て、
ブロックを取るメソッドの使い方と定義を体に染み込ませましょう!
こっちの方が簡単です。

その後で、「繰り返し処理」のためのブロックの使い方も見ていきます。

## 目立つメッセージ出力

デバッグ用途や計測用途で、出力文字列の前後に定型的な文字列を付加したいときがあります。

デバッグ用途

```
諸々
の
出力

(^o^) (^_-) (*^o^*) (T_T)
目立つ
出力
(*_*) (>_<) (;_;) (-_-#)

諸々
の
出力
```

計測用途

```
諸々
の
出力

<result>
elapsed_time = 3.321 msec
memory_consumption = 123.4 MB
</result>

諸々
の
出力
```

ブロックを使えばイイカンジで実現できます。


## mutexロック

## Enamulatable#each

ブロック内で`next`を呼ぶと`yield`直後に
