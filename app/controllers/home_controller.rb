class HomeController < ApplicationController
  def top
    @msg = 'aqualium'
  end
  def about
    @msg = 'hogehoge'
  end
end
