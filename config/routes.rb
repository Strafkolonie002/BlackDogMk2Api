Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  post '/items/bulk_insert', to: 'items#bulk_insert'
  resources :items
end
