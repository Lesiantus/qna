Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :questions do
    resources :answers, shallow: true, only: %i[create destroy index update] do
      patch :best, on: :member
    end
  end
  resources :files, only: :destroy
end
