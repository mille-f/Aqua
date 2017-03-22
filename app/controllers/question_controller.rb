class QuestionController < ApplicationController
  before_action :authenticate_user!, only: :list

  def create
    con = ActiveRecord::Base.connection
    nm = Natto::MeCab.new(userdic: "/home/vagrant/aquarium/dic/alkali.dic")

    @problem = params[:problem]
    word = Array.new
    unless @problem.blank? then
      nm.parse(@problem) do |w|
        if w.feature.split(',')[0] == '名詞' || w.feature.split(',')[0] == '動詞' then
          word.push(w.surface)
        end
      end
    end

    @e = word[0]
    @a = word[1]
    @v = params[:right]
    @w1 = params[:wrong1]
    @w2 = params[:wrong2]
    @w3 = params[:wrong3]

    @check = true
    if con.select_all("select val from alkalis where ent like '#{@e}' and att like '#{@a}' and val like '%'").to_a.empty? then
      @check = false
    end

    @res1 = con.select_all("select val from alkalis where ent like '#{@e}' and att like '#{@a}' and val like '#{@v}'")
    @res2 = con.select_all("select val from alkalis where ent like '#{@e}' and att like '#{@a}' and val like '#{@w1}'")
    @res3 = con.select_all("select val from alkalis where ent like '#{@e}' and att like '#{@a}' and val like '#{@w2}'")
    @res4 = con.select_all("select val from alkalis where ent like '#{@e}' and att like '#{@a}' and val like '#{@w3}'")

    @flag = true;
   if @check then
      if @res1.count == 0 then
        @flag = false
        @ret1 = con.select_all("select val from alkalis where ent like '#{@e}' AND att like '#{@a}' AND val like '%'")[0].to_h.fetch("val")
      end
      if @res2.count >= 1 then
        @flag = false
        @ret2 = con.select_all("select val from alkalis where ent like '#{@e}' AND att like '#{@a}' AND val like '#{@w1}'")[0].to_h.fetch("val")
      end
      if @res3.count >= 1 then
        @flag = false
        @ret3 = con.select_all("select val from alkalis where ent like '#{@e}' AND att like '#{@a}' AND val like '#{@w2}'")[0].to_h.fetch("val")
      end
      if @res4.count >= 1 then
        @flag = false
        @ret4 = con.select_all("select val from alkalis where ent like '#{@e}' AND att like '#{@a}' AND val like '#{@w3}'")[0].to_h.fetch("val")
      end
   end

   @ok = false
   if @check && @flag then @ok = true end
  end

  def list
    @role  = current_user.role.to_i
    @user  = current_user.username.to_s
    @user_id = current_user.id
    if @role == 0 then
      @data = QuestionAlkali.where(author_id: @user_id)
    elsif @role == 1 then
      @data = QuestionAlkali.all
    end
    @state = {0 => "不明", 1 => "既知", 2 => "誤り", 3 => "定着"}
    @color = {0 => "warning", 1 => "info", 2 => "danger", 3 => "success"}
  end

  def semnet
    node = Array.new
    triad = Hash.new { |h,k| h[k] = {} } # 2次元ハッシュの初期化
    state = Hash.new { |h,k| h[k] = {} } # 2次元ハッシュの初期化
    color = {0 => "#FCF8E3", 1 => "#D9EDF7", 2 => "#F2DEDE", 3 => "#DFF0D8"}
    role  = current_user.role.to_i
    user  = current_user.username.to_s.capitalize
    if role == 0 then
      data  = "#{user}Alkali".constantize.all
      data.each do |datum|
        #if datum.state == 0 then
        node.push(datum.ent)
        node.push(datum.val)
        #end
        triad[datum.ent][datum.val] = datum.att
        state[datum.ent][datum.val] = color[datum.state]
      end
      gon.triad = triad
      gon.state = state
      gon.node = node.uniq!
    end
  end

  def demo
    con = ActiveRecord::Base.connection
    nm = Natto::MeCab.new(userdic: "/home/vagrant/aquarium/dic/alkali.dic")
    #nm = Natto::MeCab.new(userdic: "/home/vagrant/aquarium/dic/ohenro.dic")
    @prob = false
    @tern2 = false
    @finish = false
    @role  = current_user.role.to_i
    @user_id = current_user.id
    @user  = current_user.username.to_s
    @transition = false # 作問フェーズからの離脱
    # 推定機能
    @is_conf_e = false
    @is_conf_a = false
    @is_conf_r = false
    @conf_e = Array.new()
    @conf_a = Array.new()
    @conf_r = Array.new()
    # 誘導作問
    nodes = Array.new()
    @all_nodes = Hash.new(0) # 全ノード
    @ack_nodes = Hash.new(0) # 既知ノード
    @intelli = Hash.new{ |h,k| h[k] = {} } # 単語、母数、理解度の三組


    if @role == 0 then
      @data  = "#{@user.capitalize}Alkali".constantize.all
      #@data  = "#{@user.capitalize}Ohenro".constantize.all
    end
    @state = {0 => "不明", 1 => "既知", 2 => "誤り", 3 => "定着"}
    @color = {0 => "warning", 1 => "info", 2 => "danger", 3 => "success"}

    node = Array.new
    triad = Hash.new { |h,k| h[k] = {} } # 2次元ハッシュの初期化
    state = Hash.new { |h,k| h[k] = {} } # 2次元ハッシュの初期化
    color = {0 => "#FCF8E3", 1 => "#D9EDF7", 2 => "#F2DEDE", 3 => "#DFF0D8"}
    @data.each do |datum|
      #if datum.state == 0 then
        node.push(datum.ent)
        node.push(datum.val)
      #end
      triad[datum.ent][datum.val] = datum.att
      state[datum.ent][datum.val] = color[datum.state]
    end
    gon.triad = triad
    gon.state = state
    gon.node = node.uniq!
    gon.cnt = 0

    # 形態素解析
    word = Array.new
    if params['ajx'].present?
      $txt = params['ajx']['problem']
      if $txt.include?("作問できません")
        @transition = true
      end
      nm.parse($txt) do |w|
        word.push(w.surface)
        if w.surface == 'の' then
          word.pop
          $e = word.join
          word.clear
        end
        if w.surface == 'は' then
          word.pop
          $a = word.join
          word.clear
        end
        #if w.feature.split(',')[0] == '名詞' || w.feature.split(',')[0] == '動詞' then
          #word.push(w.surface)
        #end
      end
      p word
      #$e = word[0]
      #$a = word[1]
      unless con.select_all("select val from alkalis where ent like '#{$e}' and att like '#{$a}' and val like '%'").to_a.empty? then
      #unless con.select_all("select val from ohenros where ent like '#{$e}' and att like '#{$a}' and val like '%'").to_a.empty? then
        @prob = true
      end
    end

    # 別名定義
    @has_alias = false # 別名定義が存在するかのフラグ
      terms1 = con.select_all("select ent from alkalis where ent like '%' and att like '名称' and val like '#{$e}'").to_a
      #terms1 = con.select_all("select ent from ohenros where ent like '%' and att like '別名' and val like '#{$e}'").to_a
      terms2 = con.select_all("select val from alkalis where ent like '#{$e}' and att like '名称' and val like '%'").to_a
      #terms2 = con.select_all("select val from ohenros where ent like '#{$e}' and att like '別名' and val like '%'").to_a
    if !terms1.empty? && terms2.empty? then
      @alias_def = terms1[0].fetch("ent")
      @has_alias = true
    end

    # 別名定義(正答)
    @has_alias_r = false # 別名定義が存在するかのフラグ
      terms1 = con.select_all("select ent from alkalis where ent like '%' and att like '別名' and val like '#{$right}'").to_a
      #terms1 = con.select_all("select ent from ohenros where ent like '%' and att like '別名' and val like '#{$right}'").to_a
      terms2 = con.select_all("select val from alkalis where ent like '#{$right}' and att like '別名' and val like '%'").to_a
      #terms2 = con.select_all("select val from ohenros where ent like '#{$right}' and att like '別名' and val like '%'").to_a
    if !terms1.empty? && terms2.empty? then
      @alias_def_r = terms1[0].fetch("ent")
      #@conf_r.push(@alias_def_r)
      @has_alias_r = true
    end

    ### 誘導作問
    # 配列にノードとなり得る値を追加
    @data.each do |datum|
      nodes.push(datum.ent)
      nodes.push(datum.val)
    end
    nodes.each do |elem|
      @all_nodes[elem] += 1 # 全ノード数のカウント
      @ack_nodes[elem] = 0  # 既知ノード数の初期化
    end
    # 隣接既知ノード数の計算
    nodes.uniq!.each do |elem|
      @data.each do |datum|
        if datum.ent == elem || datum.val == elem then
          if datum.state == 1
            @ack_nodes[elem] += 1
          end
        end
      end
    end
    # 理解度の計算
    nodes.each do |elem|
      if @all_nodes[elem] > 1
        @intelli[elem][@all_nodes[elem]] = @ack_nodes[elem] / @all_nodes[elem].to_f
      end
    end
    @intelli.sort_by {|h| h.first}.reverse

    # ドリル＆プラクティス
    @choices = Array.new()
    @data.each do |datum|
      if datum.att == "炎色反応" then
        @choices.push(datum.val)
      end
    end

    # パスをするが押されたかどうかの判定
    @is_pass = false
    if params['pass']
      @is_pass = true
    end

    # 該当なしボタンが押されたかどうかの判定
    @nohit = false
    if params['nohit']
      @nohit = true
    end

    @nohit_r = false
    if params['nohit_r']
      @nohit_r = true
    end

    # 問題文入力後、ボタンが押されたかどうかの判定
    @problem = false
    if params['problem']
      @problem = true
    end

    # 正答誤答入力後、ボタンが押されたかどうかの判定
    @create = false
    if params['create']
      @create = true
      @tern2 = true
    end

    # 元の文章を用いて問題文を修正するかどうかの判定
    @is_fix = 2
    if params['fix_yes']
      @is_fix = 1
    elsif params['fix_no']
      @is_fix = 0
    end

    # 新しく問題を作り直すかどうかの判定
    @is_new = 2
    if params['new_yes']
      @is_new = 1
    elsif params['new_no']
      @is_new = 0
    end

    # 作問を続けるかどうかの判定
    @is_continue = 2
    if params['continue_yes']
      @is_continue = 1
    elsif params['continue_no']
      @is_continue = 0
    end

    # 知識状態のリセット
    if params['reset']
      data = "#{@user.capitalize}Alkali".constantize.all
      #data = "#{@user.capitalize}Ohenro".constantize.all
      data.each do |datum|
        datum.update_attribute(:state, '0')
      end
    end

    @right_error = false
    @wrong1_error = false
    @wrong2_error = false
    @wrong3_error = false
    # 正答誤答が入力されていれば
    if params['ajx2'].present?
      @tern2 = true
      @prob = true
      $right  = params['ajx2']['right']
      $wrong1 = params['ajx2']['wrong1']
      $wrong2 = params['ajx2']['wrong2']
      $wrong3 = params['ajx2']['wrong3']

      # 正答が正しくない場合
      if con.select_all("select val from alkalis where ent like '#{$e}' and att like '#{$a}' and val like '#{$right}'").to_a.empty? then
      #if con.select_all("select val from ohenros where ent like '#{$e}' and att like '#{$a}' and val like '#{$right}'").to_a.empty? then
        @right_error = true
        @correct = con.select_all("select val from alkalis where ent like '#{$e}' and att like '#{$a}' and val like '%'").to_a[0].fetch("val")
        #@correct = con.select_all("select val from ohenros where ent like '#{$e}' and att like '#{$a}' and val like '%'").to_a[0].fetch("val")
      end
      # 誤答1が正しくない場合
      unless con.select_all("select val from alkalis where ent like '#{$e}' and att like '#{$a}' and val like '#{$wrong1}'").to_a.empty? then
      #unless con.select_all("select val from ohenros where ent like '#{$e}' and att like '#{$a}' and val like '#{$wrong1}'").to_a.empty? then
        @wrong1_error = true
      end
      # 誤答2が正しくない場合
      unless con.select_all("select val from alkalis where ent like '#{$e}' and att like '#{$a}' and val like '#{$wrong2}'").to_a.empty? then
      #unless con.select_all("select val from ohenros where ent like '#{$e}' and att like '#{$a}' and val like '#{$wrong2}'").to_a.empty? then
        @wrong2_error = true
      end
      # 誤答3が正しくない場合
      unless con.select_all("select val from alkalis where ent like '#{$e}' and att like '#{$a}' and val like '#{$wrong3}'").to_a.empty? then
      #unless con.select_all("select val from ohenros where ent like '#{$e}' and att like '#{$a}' and val like '#{$wrong3}'").to_a.empty? then
        @wrong3_error = true
      end

      if !@right_error && !@wrong1_error && !@wrong2_error && !@wrong3_error then
        @finish = true
        res = "#{@user.capitalize}Alkali".constantize.find_by(ent: "#{$e}", att: "#{$a}")
        #res = "#{@user.capitalize}Ohenro".constantize.find_by(ent: "#{$e}", att: "#{$a}")
        unless res.nil?
          res.update_attribute(:state, '1')
        end
        question = QuestionAlkali.new(question: $txt, correct: $right, wrong1: $wrong1, wrong2: $wrong2, wrong3: $wrong3, author_id: @user_id,  author_name: @user)
        #question = QuestionOhenro.new(question: $txt, correct: $right, wrong1: $wrong1, wrong2: $wrong2, wrong3: $wrong3, author_id: @user_id,  author_name: @user)
        question.save
      else
        res = "#{@user.capitalize}Alkali".constantize.find_by(ent: "#{$e}", att: "#{$a}")
        #res = "#{@user.capitalize}Ohenro".constantize.find_by(ent: "#{$e}", att: "#{$a}")
        unless res.nil?
          res.update_attribute(:state, '2')
        end
      end
    end

  end
end
