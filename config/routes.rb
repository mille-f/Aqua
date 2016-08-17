Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :users
  post 'question/create' => 'question#create'
  get 'question/create'
  get 'question/list' => 'question#list'
  get 'question/semnet' => 'question#semnet'
  #get 'question/demo' => 'question#demo'
  match 'question/demo', as: 'demo', to: 'question#demo', via: [:get, :post]

  root 'home#top'
  get '/show' => 'home#show'
  get '/about' => 'home#about'

end
