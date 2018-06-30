Rails.application.routes.draw do
  root to: 'radio_stations#top'

  resources :radio_stations do
    collection do
      post :confirm
    end
  end

  resources :sessions, only: [:new, :create, :destroy]

  resources :users do
    collection do
      post :confirm
    end
    resources :favorite_stations, only: [:index]
  end

  resources :favorites, only: [:create, :destroy]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
