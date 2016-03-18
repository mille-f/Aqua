class HomeController < ApplicationController
  def top
    @msg = 'aquarium'
  end
  def about
    @msg = 'hogehoge'
  end
end
