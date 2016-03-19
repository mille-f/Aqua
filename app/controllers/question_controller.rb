class QuestionController < ApplicationController
  def create
  end

  def list
    @data = Alkali.all
  end
end
