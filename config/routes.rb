Rails.application.routes.draw do
  post 'token', to: 'oauth2#create'
  post 'revoke', to: 'oauth2#destroy'
end
