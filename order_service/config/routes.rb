Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :orders, only: [:create, :index]
    end
  end

end