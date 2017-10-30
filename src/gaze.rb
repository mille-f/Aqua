require 'natto'

@natto = Natto::MeCab.new(userdic: "/home/vagrant/aquarium/dic/syuukihyou.dic")
data = Hash.new

File.open("../subtitles/subtitles.txt", mode: "rt:sjis:utf-8") do |f|
  f.each_line do |l|
    if l =~ /^[0-9]+$/
      time = l.to_i
    end
    data[time] = f.gets.chomp
  end
end

puts "input time"
print "> "
time = gets.to_i

#p data

data.each_with_index do |(key, val), i|
  min = data.key(data[data.keys[i]])
  max = data.key(data[data.keys[i+1]])-1
  if time.between?(min,max)
    puts "#{min} ~ #{max}"
    puts val
    puts ""
    @natto.parse(val) do |n|
      if n.feature =~ /\A名詞,|^動詞,/
        puts "#{n.surface} #{n.feature}"
      end
    end
    break
  end
end
