Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :twitter_profiles, only: [:index, :new, :create, :show]

  root to: 'twitter_profiles#new'
end
