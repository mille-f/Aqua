class DrillController < ApplicationController
  def drill
    con = ActiveRecord::Base.connection
    @role  = current_user.role.to_i
    @user  = current_user.username.to_s.capitalize
    @base  = "#{@user}Alkali".constantize

    if @role == 0 then
      @data  = @base.all
      @size = @data.size # 知識ベースのサイズ
      @set = (1..@size).to_a.sample(19) #20個ランダム
    end

    @is_hit = false
    if params['pass'] then
      @is_hit = true
    end

  end
end
