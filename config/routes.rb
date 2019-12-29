Rails.application.routes.draw do
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
  resources :signed_contracts, only: [:create, :index, :destroy]

  root 'top#index'
  get 'top/policy' => 'top#policy'
  get 'contracts/search' => 'contracts#search'
  post 'contracts/show' => 'contracts#show'
  post 'contracts/combine' => 'contracts#combine'
  post 'contracts/create_signed_pdf' => 'contracts#create_signed_pdf'
  get 'signed_contracts/every_templete_index' => 'signed_contracts#every_templete_index'

  get 'contracts/api_request' => 'contracts#api_request'
  post 'contracts/api_response' => 'contracts#api_response'
end
