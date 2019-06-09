Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :posts, only: %i[create] do
        put :rate, on: :member
        get :top, on: :collection
      end
    end
  end
end
