Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  resources :items
  post '/items/bulk_upsert', to: 'items#bulk_upsert'
  resources :materials
  post '/materials/create_materials', to: 'materials#create_materials'
  post '/materials/update_materials', to: 'materials#update_materials'

end
