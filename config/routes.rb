Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]
  resources :contracts, only: [:new, :create, :index]
  root 'contracts#search'
  post 'contracts/show' => 'contracts#show'

  post 'contracts/create_pdf' => 'contracts#create_pdf'
end
