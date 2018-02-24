Rails.application.routes.draw do
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]
 
  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  resources :listings do
    collection do
      # additional path
      get 'search' => "listings#search"
    end
  end
 
  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  # root to: "pages#index"
  resources :pages, only: :new

  constraints Clearance::Constraints::SignedOut.new do
    root to: 'listings#index'
  end
  constraints Clearance::Constraints::SignedIn.new do
    root to: 'listings#index', as: :signed_in_root
  end

  # "sign in with facebook" routes
  get "/auth/:provider/callback" => "sessions#create_from_omniauth"
end
