Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'   
  } 

  devise_scope :user do
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy" 
  end

  resources :users, only: [:show]
  resources :contracts, only: [:new, :create, :index, :destroy]
  resources :signed_contracts, only: [:create, :index, :show, :destroy]
  root 'contracts#search'
  post 'contracts/show' => 'contracts#show'
  post 'contracts/combine' => 'contracts#combine'
  post 'contracts/create_signed_pdf' => 'contracts#create_signed_pdf'

  get 'contracts/api_request' => 'contracts#api_request'
  post 'contracts/api_response' => 'contracts#api_response'
end
