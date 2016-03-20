class QuestionController < ApplicationController
  def create
    con = ActiveRecord::Base.connection
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
    @w1 = params[:wrong1]
    @w2 = params[:wrong2]
    @w3 = params[:wrong3]

    @check = true
    if con.select_all("select val from alkalis where ent like '#{@e}' and att like '#{@a}' and val like '%'").to_a.empty? then
      @check = false
    end

    @res1 = con.select_all("select val from alkalis where ent like '#{@e}' and att like '#{@a}' and val like '#{@v}'")
    @res2 = con.select_all("select val from alkalis where ent like '#{@e}' and att like '#{@a}' and val like '#{@w1}'")
    @res3 = con.select_all("select val from alkalis where ent like '#{@e}' and att like '#{@a}' and val like '#{@w2}'")
    @res4 = con.select_all("select val from alkalis where ent like '#{@e}' and att like '#{@a}' and val like '#{@w3}'")

    @flag = true;
   if @check then
      if @res1.count == 0 then
        @flag = false
        @ret1 = con.select_all("select val from alkalis where ent like '#{@e}' AND att like '#{@a}' AND val like '%'")[0].to_h.fetch("val")
      end
      if @res2.count >= 1 then
        @flag = false
        @ret2 = con.select_all("select val from alkalis where ent like '#{@e}' AND att like '#{@a}' AND val like '#{@w1}'")[0].to_h.fetch("val")
      end
      if @res3.count >= 1 then
        @flag = false
        @ret3 = con.select_all("select val from alkalis where ent like '#{@e}' AND att like '#{@a}' AND val like '#{@w2}'")[0].to_h.fetch("val")
      end
      if @res4.count >= 1 then
        @flag = false
        @ret4 = con.select_all("select val from alkalis where ent like '#{@e}' AND att like '#{@a}' AND val like '#{@w3}'")[0].to_h.fetch("val")
      end
   end

   @ok = false
   if @check && @flag then @ok = true end
  end

  def list
    @data = Alkali.all
  end
end
