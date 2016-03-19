class QuestionController < ApplicationController
  def create
    nm = Natto::MeCab.new(userdic: "/home/vagrant/aquarium/dic/alkali.dic")
    @problem = params[:problem]
    word = Array.new
    unless @problem.blank? then
      nm.parse(@problem) do |w|
        if w.feature.split(',')[0] == '名詞' || w.feature.split(',')[0] == '動詞' then
          word.push(w.surface)
        end
      end
    end

    @e = word[0]
    @a = word[1]
    @v = params[:right]
    w1 = params[:wrong1]
    w2 = params[:wrong2]
    w3 = params[:wrong3]

    con = ActiveRecord::Base.connection
    @res1 = con.select_all("select val from alkalis where ent like '#{@e}' and att like '#{@a}' and val like '#{@v}'").to_a
  end

  def list
    @data = Alkali.all
  end
end
