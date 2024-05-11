Rails.application.routes.draw do
  root to: "home#index"

  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations'
  }

  # Rutas para usuarios, incluyendo perfil y eliminación
  resources :users, only: [:destroy, :show] do
    member do
      get :profile, as: 'profile'
    end
  end

  # Namespace for admin with a more explicit dashboard route
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  resources :classrooms, only: [:show, :edit, :update, :destroy]
  patch 'users/:id/approve', to: 'users#approve', as: 'approve_user'
  end

  # Ruta para usuarios en espera de aprobación
  get 'waiting_approval', to: 'static_pages#waiting_approval'

  # Rutas para gestionar classrooms y class sessions
  resources :classrooms, only: [:new, :create, :show, :index, :edit, :update, :destroy]
  resources :class_sessions
end
