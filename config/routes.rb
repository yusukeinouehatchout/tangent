Rails.application.routes.draw do
  resources :contracts, only: [:new, :create, :index]
  # get 'contracts_search' => 'contracts#search'
  root 'contracts#search'
  post 'contracts/show' => 'contracts#show'
end
