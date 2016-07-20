Rails.application.routes.draw do
  root to: 'home#index'
  post '/upload', to: 'home#upload'
  post '/split', to: 'home#split'

  get '/regexp', to: 'regexp#show'
end
