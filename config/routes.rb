Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  resource :signup, only: %i[create]
  resources :authentications, only: %i[create]
  resources :users, only: [:index, :destroy] do 
    member do
      put :archive
      put :unarchive
    end
  end
end
