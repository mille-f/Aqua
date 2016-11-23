class DrillController < ApplicationController
  def drill
    con = ActiveRecord::Base.connection
    @role  = current_user.role.to_i
    @user  = current_user.username.to_s.capitalize
    @base  = "#{@user}Alkali".constantize
    @finish = false
    @@cnt = 0
    @question = []

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
    text = @base.find(num).ent + "の" + @base.find(num).att + "は何ですか？"
    right = @base.find(num).val
    @question << [text, right, "hoge", "foo", "bar"]

    @is_start = false
    if params['start'] then
      @is_start = true
    end

    @is_push = false
    if params['pass'] then
      @is_push = true
    end

    @is_right = false
    if params['right'] then
      @is_right = true
    end

  end
end
