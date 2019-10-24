Rails.application.routes.draw do
  resources :contracts, only: [:new, :create, :index]
  root 'contracts#search'
  post 'contracts/show' => 'contracts#show'
end
