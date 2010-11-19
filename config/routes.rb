VirtualToken::Application.routes.draw do
  devise_for :users
  resources :tokens
  root :to => 'tokens#new'
end
