namespace :api, defaults: { format: :json } do
  resources :tests, path: 'tests', only: [:index]
end