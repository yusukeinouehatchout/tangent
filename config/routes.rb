Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]
  resources :contracts, only: [:new, :create, :index]
  root 'contracts#search'
  post 'contracts/show' => 'contracts#show'

  post 'contracts/combine' => 'contracts#combine'
  post 'contracts/create_signed_pdf' => 'contracts#create_signed_pdf'
end
