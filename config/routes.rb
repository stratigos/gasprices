Rails.application.routes.draw do

  # index page route
  root 'homepage#index'

  # about page route
  get 'about' => 'homepage#about', :as => 'about'

  # API endpoints
  namespace :api do
    namespace :v1 do
      get 'states',       to: 'states#index'
      get 'states/:name', to: 'states#show'
    end
  end
  
end
