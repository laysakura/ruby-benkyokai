ProcとBlock
====

## 用語集
- Proc
  - procとlambda
- Block
- プロシージャとは
- 

### pryで確かめよう

```ruby
l = lambda {|x| x + 1}  #=> #<Proc:0x007fd389842858@(pry):1 (lambda)>
pry(main)> l.class  #=> Proc
```