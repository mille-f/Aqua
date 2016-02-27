require 'pg'

connect = PG::connect(dbname: 'test1')

print "entity => "
e = gets.chomp
print "attribute => "
a = gets.chomp
print "value => "
v = gets.chomp
puts "Q(" + e + ", " + a + ", " + v + ")"

if e == "*" then e = "%" end
if a == "*" then a = "%" end
if v == "*" then v = "%" end

results = connect.exec("select * from alkali where entity like '#{e}' AND attribute like '#{a}' AND value like '#{v}'")
c = results.count

if c == 0 then puts "Flase" end

results.each do |result|
  p result
end

connect.finish
