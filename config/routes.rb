Rails.application.routes.draw do

  devise_for :users
  post 'question/create' => 'question#create'
  get 'question/create'
  get 'question/list' => 'question#list'

  root 'home#top'
  get '/show' => 'home#show'
  get '/about' => 'home#about'

end
