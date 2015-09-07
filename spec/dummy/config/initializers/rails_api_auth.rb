RailsApiAuth.tap do |raa|
  raa.user_model_relation = :account

  raa.facebook_app_id       = 'app_id'
  raa.facebook_app_secret   = 'app_secret'
  raa.facebook_graph_url    = 'https://graph.facebook.com'
  raa.facebook_redirect_uri = 'redirect_uri'

  raa.google_client_id = 'google_client_id'
  raa.google_client_secret = 'google_client_secret'
  raa.google_redirect_uri = 'google_redirect_uri'
end
