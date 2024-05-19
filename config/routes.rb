Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations'
  }

  # Definir ruta de perfil fuera de resources :users
# config/routes.rb
get 'profile', to: 'users#profile', as: 'user_profile'



resources :users, only: [:destroy, :show] do
  member do
    get :profile, as: 'profile'
  end
end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'

      resources :classrooms, only: [:show, :edit, :update, :destroy]
      patch 'users/:id/approve', to: 'users#approve', as: 'approve_user'

      resources :coders, only: [:index]  # Asegurando que index responda a JS
  end

  get 'waiting_approval', to: 'static_pages#waiting_approval'
  resources :classrooms, only: [:new, :create, :show, :index, :edit, :update, :destroy]
  resources :class_sessions

  resources :workshops do
    resources :lessons do
      member do
        post 'toggle_completion'
      end
    end
  end

  resources :dashboard, only: [:index], controller: 'admin/dashboard'

end
