class HomeController < ApplicationController
  def top
    @msg = 'Active S-Quiz'
  end

  def about
    @msg = 'hogehoge'
  end

  def show
  end

  def gaze
    @output = false
    if params['output'] then
      @output = true
      #p params[:id]
    end
  end

  def video

  end
end
