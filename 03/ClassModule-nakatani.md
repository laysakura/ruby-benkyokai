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


# ブロック・マニアックス

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

## mutexロック

## Enamulatable#each

ブロック内で`next`を呼ぶと`yield`直後に
