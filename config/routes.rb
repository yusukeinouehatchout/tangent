Rails.application.routes.draw do
  resources :contracts, only: [:new]
end
