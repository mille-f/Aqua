Rails.application.routes.draw do

  post 'question/create' => 'question#create'
  get 'question/create'
  get 'question/list' => 'question#list'

  root 'home#top'
  get '/about' => 'home#about'

end
