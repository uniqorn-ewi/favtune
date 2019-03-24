Rails.application.routes.draw do
  root   'radio_stations#top'

  get    '/signup',   to: 'users#new'

  get    '/signin',   to: 'sessions#new'
  post   '/signin',   to: 'sessions#create'
  delete '/signout',  to: 'sessions#destroy'

  resources :radio_stations do
    collection do
      post :confirm
    end
  end

  resources :users, except: [:index, :new] do
    collection do
      post :confirm
    end
    resources :favorite_stations, only: [:index]
  end

  resources :favorites, only: %i[ create destroy ]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
