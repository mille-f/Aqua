class QuestionController < ApplicationController
  def create
    @problem = params[:problem]
    @right = params[:right]
    @wrong1 = params[:wrong1]
    @wrong2 = params[:wrong2]
    @wrong3 = params[:wrong3]
    con = ActiveRecord::Base.connection
    @res1 = con.select_all('select val from alkalis').to_a
  end

  def list
    @data = Alkali.all
  end
end
