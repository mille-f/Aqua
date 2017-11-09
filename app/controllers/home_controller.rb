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
      gaze = params['gaze'].values.join.split(",").map(&:to_i)
      #gaze.map! {|i| i+=1}

      data.each do |datum|
        puts "#{datum.keyword} #{datum.start} #{datum.end} #{datum.watch}"
#=begin
        unless gaze.empty?
          if gaze[datum.start..datum.end].all? {|n| n > 0}
            p gaze[datum.start..datum.end]
            datum.update_attribute(:watch, true)
          else
            datum.update_attribute(:watch, false)
          end
        end
#=end
      end
    end
  end

  def video

  end
end
