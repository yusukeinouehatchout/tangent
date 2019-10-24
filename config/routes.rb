Rails.application.routes.draw do
  # resources :contracts, only: [:new, :create, :index]
  resources :contracts, only: [:create, :index]
  get 'contracts_search' => 'contracts#search'
  root 'contracts#new'
  post 'contracts/show' => 'contracts#show'
end
