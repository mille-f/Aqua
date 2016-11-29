class DrillController < ApplicationController
  def drill
    con = ActiveRecord::Base.connection
    @role  = current_user.role.to_i
    @user  = current_user.username.to_s.capitalize
    @base  = "#{@user}Alkali".constantize
    @finish = false
    @max = 20
    @question = Array.new()
    @erratum = { -1 => "danger", 0 => "default", 1 => "success" }
    gon.cnt = 1
    gon.res = Array.new(@max, 0)
    @result = gon.res #Array.new(@max, 0)


    if @role == 0 then
      @data  = @base.all
      @size = @data.size # 知識ベースのサイズ
      #@set = (1..@size).to_a.sample(20) #20個ランダム
    end

    #@set.each do |num|
    #  text = @base.find(num).ent + "の" + @base.find(num).att + "は何ですか？"
    #  right = @base.find(num).val
    #  @question << [text, right, "hoge", "foo", "bar"]
    #end

    num = rand(1..@size)
    @prob = @base.find(num).ent + "の" + @base.find(num).att + "は何ですか？"
    @right = @base.find(num).val
    @w1 = @base.find(num%5+3).val
    @w2 = @base.find(num%5+2).val
    @w3 = @base.find(num%5+1).val

    @question << @right
    @question << @w1
    @question << @w2
    @question << @w3

  end
end
