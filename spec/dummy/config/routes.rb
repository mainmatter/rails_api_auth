Rails.application.routes.draw do
  get '/authenticated' => 'authenticated#index'
end
