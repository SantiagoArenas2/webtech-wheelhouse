Rails.application.routes.draw do
  root "pages#home"
  get "visit", to: "pages#visit", as: :visit
  get "about", to: "pages#about", as: :about

  resources :customers, only: [ :index, :show ]
  resources :bikes, only: [ :index, :show ]
  resources :repair_jobs, only: [ :index, :show ], path: "repairs", as: "repairs"
  resources :service_catalogue_items, only: [ :index, :show ], path: "services", as: "services", controller: "services"
  resources :staff_members, only: [ :index, :show ], path: "staff"
end
