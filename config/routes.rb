Rails.application.routes.draw do
  resources :contracts, only: [:new, :create, :index]
  get 'contracts/search' => 'contracts#search'
end
