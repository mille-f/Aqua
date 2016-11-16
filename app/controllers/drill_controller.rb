class DrillController < ApplicationController
  def drill
    @cnt = 1

    @is_hit = false
    if params['pass'] then
      @is_hit = true
      @cnt += 1
    end
  end
end
