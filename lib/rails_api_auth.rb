require 'rails_api_auth/engine'

module RailsApiAuth

  mattr_accessor :facebook_app_id
  mattr_accessor :facebook_app_secret
  mattr_accessor :facebook_graph_url
  mattr_accessor :facebook_redirect_uri

end
