VirtualToken::Application.routes.draw do
  devise_for :users
  resources :tokens do
    resources :token_requests, :as => :requests
  end
  root :to => 'tokens#new'
end
