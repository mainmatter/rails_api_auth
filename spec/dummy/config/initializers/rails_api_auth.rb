RailsApiAuth.tap do |raa|
  raa.user_model_relation = :account

  raa.facebook_app_id       = 'app_id'
  raa.facebook_app_secret   = 'app_secret'
  raa.facebook_graph_url    = 'https://graph.facebook.com'
  raa.facebook_redirect_uri = 'redirect_uri'
end
