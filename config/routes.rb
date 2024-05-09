Rails.application.routes.draw do
  root to: "home#index"

  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations'
  }

  # Rutas para administrar usuarios, incluido eliminar
  resources :users, only: [:destroy, :show] do
    member do
      get :profile, action: :show, as: 'profile'
    end
  end

  resources :admin, only: [:index]
  patch 'admin/approve_user/:id', to: 'admin#approve', as: 'approve_user'

  get 'waiting_approval', to: 'static_pages#waiting_approval'

  resources :classrooms, only: [:new, :create, :show, :index, :edit, :update, :destroy]
  resources :class_sessions
end
