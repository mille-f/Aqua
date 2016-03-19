Rails.application.routes.draw do

  get 'question/create'
  get 'question/list' => 'question#list'

  root 'home#top'
  get '/about' => 'home#about'

end
