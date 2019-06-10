Rails.application.routes.draw do
  mount Raddocs::App => '/docs'

  namespace :api do
    namespace :v1 do
      resources :posts, only: %i[create] do
        put :rate, on: :member
        get :top, on: :collection
      end

      get '/user_ips/groups', to: 'user_ips#groups'
    end
  end
end
