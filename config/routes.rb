require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :orders, only: [] do
    collection {post 'track'}
  end
end
