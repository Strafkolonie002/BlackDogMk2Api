Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :items
  resources :receive_orders
  resources :ship_orders
  resources :order_details
  resources :materials
  resources :barcodes
  resources :stock_materials
  resources :pick_materials
  resources :ship_materials
  resources :containers
end
