Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :polls, only: [:show, :create] do
    resources :votes, only: [:create]
    resources :results, only: [:index]
  end
end
