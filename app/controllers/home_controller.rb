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
    data = KeywordPeriodictable.all
    if params['output'] then
      data.each do |datum|
        puts "#{datum.keyword} #{datum.start} #{datum.end} #{datum.watch}"
      end
      p params['gaze'].values.join.split(",").map(&:to_i)
    end
  end

  def video

  end
end
