Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations'
  }

  resources :users, only: [:destroy, :show] do
    member do
      get :profile, as: 'profile'
    end
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :classrooms, only: [:show, :edit, :update, :destroy]
    patch 'users/:id/approve', to: 'users#approve', as: 'approve_user'
  end

  get 'waiting_approval', to: 'static_pages#waiting_approval'
  resources :classrooms, only: [:new, :create, :show, :index, :edit, :update, :destroy]
  resources :class_sessions

  resources :workshops do
    resources :lessons
  end

end
