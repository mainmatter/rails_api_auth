Rails.application.routes.draw do
  get '/authenticated'        => 'authenticated#index'
  get '/custom-authenticated' => 'custom_authenticated#index'
  get '/access-once'          => 'access_once#index'
end
