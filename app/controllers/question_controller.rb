class QuestionController < ApplicationController
  def make
  end

  def list
    @data = Alkali.all
  end
end
