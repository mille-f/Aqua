# coding: utf-8

require "gviz"
require "mysql2"

#gv = Gviz.new
client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :database => 'testcase')

Graph do
  global overlap: false
  nodes fontname:'MS GOTHIC'
  client.query("select ent, att, val from test1_alkalis").each do |q|
    ent = q.fetch("ent").gsub(/[^\d\w:-]/, " ")
    att = q.fetch("att").gsub(/[^\d\w:-]/, " ")
    val = q.fetch("val").gsub(/[^\d\w:-]/, " ")
    a = "hoge"
    b = "poge"
    puts "#{ent} #{att} #{val}"
    #route  node["ent"] => node["val"]
    #edge :"#{ent}_#{val}"
  end
  edge :"あ_い"
  save(:alkali, :png)
end

