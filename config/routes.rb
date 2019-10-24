Rails.application.routes.draw do
  devise_for :users
  resources :contracts, only: [:new, :create, :index]
  root 'contracts#search'
  post 'contracts/show' => 'contracts#show'
end
