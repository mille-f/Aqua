class HomeController < ApplicationController
  def top
    @msg = 'Active S-Quiz'
  end
  def about
    @msg = 'hogehoge'
  end
end
