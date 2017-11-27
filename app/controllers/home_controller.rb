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
    model = Test1Periodictable.all

    arr = []
    cnt = Hash.new(0)

    if params['output'] then
      gaze = params['gaze'].values.join.split(",").map(&:to_i)
      data.each do |datum|
        puts "#{datum.keyword} #{datum.start} #{datum.end} #{datum.watch}"
        # startからendまで見ていればwatchをtrue
        unless gaze.empty?
          if gaze[datum.start..datum.end].all? {|n| n > 0}
            datum.update_attribute(:watch, true)
          else
            datum.update_attribute(:watch, false)
          end
        end
      end
    end

    data.order(:keyword).each do |datum|
      if datum.watch # watchがtrueならば
        #p datum
=begin
        p ent = Test1Periodictable.find_by(ent: datum.keyword)
        p att = Test1Periodictable.find_by(att: datum.keyword)
        p val = Test1Periodictable.find_by(val: datum.keyword)
=end
        model.each do |i|
          if i.state == 0
            k = datum.keyword
            if (i.ent == k) || (i.att == k) || (i.val == k)
              arr << k
            end
          end
        end
      end
    end

    arr.each do |e|
      cnt[e] += 1
    end
    p cnt.sort_by {|k,v| -v}

  end

  def video

  end
end
