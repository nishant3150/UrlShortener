Rails.application.routes.draw do
  devise_for :views
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'shortened_links#index'
  resources :shortened_links
  get '/s/*path' => 'shortened_links#translate'
end