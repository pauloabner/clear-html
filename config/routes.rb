Rails.application.routes.draw do
  root to: 'home#index'
  post '/upload', to: 'home#upload'
  post '/split', to: 'home#split'
  post '/generate', to: 'home#generate'

  get '/regexp', to: 'regexp#show'
  post '/regexp_update', to: 'regexp#update'
end
