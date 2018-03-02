Rails.application.routes.draw do

  get 'search/search'

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]
 
  resources :users, controller: "users", only: [:show, :create, :edit, :update, :delete] do
    resource :password, controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  post '/search', to: 'search#search'

  get 'reservations/index' => 'reservations#index'

  resources :listings do
    collection do
      # additional path
      get 'search' => "listings#search"
    end

    resources :reservations do
      # confirmation page after reservation#new
      collection do
        get 'confirm' => 'reservations#confirm'
      end
    end
  end
 
  get "/sign_in" => "sessions#new", as: "sign_in"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  constraints Clearance::Constraints::SignedOut.new do
    root to: 'listings#index'
  end
  constraints Clearance::Constraints::SignedIn.new do
    root to: 'listings#index', as: :signed_in_root
  end

  # "sign in with facebook" routes
  get "/auth/:provider/callback" => "sessions#create_from_omniauth"
end
