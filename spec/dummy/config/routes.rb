Rails.application.routes.draw do
  get '/authenticated'        => 'authenticated#index'
  get '/custom-authenticated' => 'custom_authenticated#index'
end
