require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    match '/after_sign_up_unconfirmed/:id', to: 'confirmations#after_sign_up_unconfirmed', via: [:get, :patch], as: 'after_sign_up_unconfirmed'
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end

  root to: 'questions#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/search', to: 'search#search'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  concern :commentable do
    member do
      post :add_comment
    end
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :subscriptions, shallow: true, only: %i[create destroy]
    resources :answers, shallow: true, only: %i[create destroy index update], concerns: %i[votable commentable] do
      patch :best, on: :member
    end
  end
  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  mount ActionCable.server => '/cable'
end
