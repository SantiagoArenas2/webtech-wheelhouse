Rails.application.routes.draw do
  resources :users, only: %i[ new create ]

  resource :session
  resources :passwords, param: :token
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :services, only: %i[index show create]
      resources :repairs, only: %i[index show]
    end
  end

  root "pages#home"
  get "visit", to: "pages#visit", as: :visit
  get "about", to: "pages#about", as: :about

  resources :customers
  resources :bikes
  resources :repair_jobs, path: "repairs", as: "repairs"
  delete "repairs/:repair_job_id/intake_photos/:id", to: "repair_photos#destroy", as: :repair_job_intake_photo
  resources :service_catalogue_items, path: "services", as: "services", controller: "services"
  resources :staff_members, path: "staff"
end
