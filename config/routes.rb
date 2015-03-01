Rails.application.routes.draw do
  devise_for :users

  namespace :api, constraints: { subdomain: 'api' }, path: '/', defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :lists, only: [:index]
    end
  end
end
