RailsApiAuth.tap do |raa|
  raa.user_model_relation = :account

  raa.facebook_app_id       = 'app_id'
  raa.facebook_app_secret   = 'app_secret'
  raa.facebook_redirect_uri = 'redirect_uri'

  raa.google_client_id = 'google_client_id'
  raa.google_client_secret = 'google_client_secret'
  raa.google_redirect_uri = 'google_redirect_uri'

  raa.github_client_id = 'github_client_id'
  raa.github_client_secret = 'github_client_secret'
  raa.github_redirect_uri = 'github_redirect_uri'

  raa.edx_client_id     = 'edx_client_id'
  raa.edx_client_secret = 'edx_client_secret'
  raa.edx_domain        = 'edxdomain.org'
  raa.edx_redirect_uri  = 'edx_redirect_uri'
end
