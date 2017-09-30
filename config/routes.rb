Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :users
  post 'question/create' => 'question#create'
  get 'question/create'
  get 'question/list' => 'question#list'
  get 'question/semnet' => 'question#semnet'
  get 'question/semnet2' => 'question#semnet2'
  #get 'question/demo' => 'question#demo'
  match 'question/demo', as: 'demo', to: 'question#demo', via: [:get, :post]

  get 'drill/drill' => 'drill#drill'
  match 'drill/drill', as: 'drill', to: 'drill#drill', via: [:get, :post]

  root 'home#top'
  get '/show'  => 'home#show'
  get '/about' => 'home#about'
  get '/gaze'  => 'home#gaze'
  get '/video' => 'home#video'

end
