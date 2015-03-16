Rails.application.routes.draw do
  devise_for :users

  namespace :api, constraints: { subdomain: 'api' }, path: '/', defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:show, :update]
      resources :lists, except: [:new, :edit] do
        resources :tasks, only: [:create, :update]
      end
    end
  end
end
