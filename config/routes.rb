Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, only: %i[create destroy index update], concerns: [:votable] do
      patch :best, on: :member
    end
  end
  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  mount ActionCable.server => '/cable'
end
