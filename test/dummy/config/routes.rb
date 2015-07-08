Rails.application.routes.draw do

  mount RailsApiAuth::Engine => "/rails_api_auth"
end
