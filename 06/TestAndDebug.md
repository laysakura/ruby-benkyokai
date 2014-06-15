# 前回の疑問解消

## [`include`をした時の正確な動作](https://github.com/laysakura/ruby-benkyokai/issues/11)



## [モジュールの`include`が継承よりも「いい」理由](https://github.com/laysakura/ruby-benkyokai/issues/12)

[前回の文脈](https://github.com/laysakura/ruby-benkyokai/blob/master/05/Module-nakatani.md#%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB%E3%81%AB%E3%82%88%E3%82%8Bmix-in) では、`Compressor`クラスを継承して`Gzip`や`Snappy`クラスを作るよりは、`Compressor`モジュールを`include`して`Gzip`や`Snappy`クラスを作るほうが良いという話をしました。
`Compressor`と`Gzip`にはいわゆる`is-a`関係があるのに、なぜ継承ではだめなのでしょうか。

考えてみると理由はシンプルで、 **`Compressor`は抽象クラスだから** です。
「抽象クラス」はRubyの用語でないのですが、「一部のメソッドがインターフェイスだけ提供されているためインスタンス化できないクラス」のことです。

元の例では、`Compressor`は`compress!`というインターフェイスを提供しています。
これをインスタンス化しても実際に圧縮器としての動作はできないので、`class`にするよりも`module`にしたほうが使い方を明確化できます。

逆に言えば、`is-a`関係があり、継承元もインスタンス化して意味を持つのであれば継承を使うべきです。
例えば、単体でもログを出力する機能を持つ`Logger`クラスを継承して、ANSIカラーコードによる色付きログを出力する`ColorfulLogger`を継承する場合などが考えられます。


## [ActiveSupportの文脈で出てきた`alias`の正体](https://github.com/laysakura/ruby-benkyokai/issues/13)

島田お願いします!


# 前回の復習

# Rubyでのテストとデバッグ

# 宿題
