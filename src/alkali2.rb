require 'pg'
require 'natto'

@connect = PG::connect(dbname: 'test1')
@natto = Natto::MeCab.new(userdic: "/home/vagrant/aquarium/dic/alkali.dic")

puts "問題を作成してください。(例:XのYは何ですか？)"
print "=> "
txt = gets.chomp

noun = Array.new
@natto.parse(txt) do |n|
  if n.feature.split(',')[0] == '名詞' || n.feature.split(',')[0] == '動詞' then
    noun.push(n.surface)
  end
end
e = noun[0]
a = noun[1]

print "正答=> "
v = gets.chomp
print "誤答1=> "
w1 = gets.chomp
print "誤答2=> "
w2 = gets.chomp
print "誤答3=> "
w3 = gets.chomp

def search(e, a, v)
    @connect.exec("select * from alkali where entity like '#{e}' AND attribute like '#{a}' AND value like '#{v}'")
end

res1 = search(e, a, v)
res2 = search(e, a, w1)
res3 = search(e, a, w2)
res4 = search(e, a, w3)

def right(e, a)
    @connect.exec("select value from alkali where entity like '#{e}' AND attribute like '#{a}' AND value like '%'")[0].to_h.fetch("value")
end

puts ""
if res1.count == 0 then
    puts "正答が間違っています。"
    puts "正しくは、#{e}の#{a}は#{right(e, a)}です。"
elsif res2.count >= 1 then
    puts "誤答1が間違っています。"
    puts "#{e}の#{a}は#{right(e, a)}は正しいです。"
elsif res3.count >= 1 then
    puts "誤答2が間違っています。"
    puts "#{e}の#{a}は#{right(e, a)}は正しいです。"
elsif res4.count >= 1 then
    puts "誤答3が間違っています。"
    puts "#{e}の#{a}は#{right(e, a)}は正しいです。"
else puts "良い問題ですね。" end

@connect.finish
