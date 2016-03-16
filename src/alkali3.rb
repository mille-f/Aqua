require 'pg'
require 'natto'

@connect = PG::connect(dbname: 'test1')
@natto = Natto::MeCab.new(userdic: "/home/vagrant/aquarium/dic/alkali.dic")

def imput
  puts "問題を作成してください。(例:XのYは何ですか？)"
  print "=> "
  txt = gets.chomp

  noun = Array.new
  @natto.parse(txt) do |n|
    if n.feature.split(',')[0] == '名詞' || n.feature.split(',')[0] == '動詞' then
      noun.push(n.surface)
    end
  end

  @e = noun[0]
  @a = noun[1]
end

def check(e, a)
  res = @connect.exec("select * from alkali where entity like '#{e}' AND attribute like '#{a}' AND value like '%'")
  if res.to_a.empty? then
    puts "問題文が正しくありません。問題を作りなおしてください。"
    puts ""
    return false
  else return true end
end

def search(e, a, v)
  @connect.exec("select * from alkali where entity like '#{e}' AND attribute like '#{a}' AND value like '#{v}'")
end

def right(e, a)
  @connect.exec("select value from alkali where entity like '#{e}' AND attribute like '#{a}' AND value like '%'")[0].to_h.fetch("value")
end

def wrong(e, a, v)
  @connect.exec("select value from alkali where entity like '#{e}' AND attribute like '#{a}' AND value like '#{v}'")[0].to_h.fetch("value")
end

imput
while !check(@e, @a) do
  imput
end

print "正答=> "
v = gets.chomp
print "誤答1=> "
w1 = gets.chomp
print "誤答2=> "
w2 = gets.chomp
print "誤答3=> "
w3 = gets.chomp

res1 = search(@e, @a, v)
res2 = search(@e, @a, w1)
res3 = search(@e, @a, w2)
res4 = search(@e, @a, w3)

puts ""

flag = false
if res1.count == 0 then
    puts "正答が間違っています。"
    puts "正しくは、#{@e}の#{@a}は#{right(@e, @a)}です。"
    flag = true
end
if res2.count >= 1 then
    puts "誤答1が間違っています。"
    puts "「#{@e}の#{@a}は#{wrong(@e, @a, w1)}」は正しいです。"
    flag = true
end
if res3.count >= 1 then
    puts "誤答2が間違っています。"
    puts "「#{@e}の#{@a}は#{wrong(@e, @a, w2)}」は正しいです。"
    flag = true
end
if res4.count >= 1 then
    puts "誤答3が間違っています。"
    puts "「#{@e}の#{@a}は#{wrong(@e, @a, w3)}」は正しいです。"
    flag = true
end

if flag == false then puts "良い問題ですね。" end

@connect.finish
