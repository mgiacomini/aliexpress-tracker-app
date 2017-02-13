Rails.application.routes.draw do
  resources :orders, only: [] do
    post 'track'
  end
end
