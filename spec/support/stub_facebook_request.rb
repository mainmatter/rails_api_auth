def stub_facebook_request(auth_code, account_response)
  allow(RailsApiAuth).to receive(:facebook_app_id).and_return('app_id')
  allow(RailsApiAuth).to receive(:facebook_app_secret).and_return('app_secret')
  allow(RailsApiAuth).to receive(:facebook_graph_url).and_return('https://graph.facebook.com')
  allow(RailsApiAuth).to receive(:facebook_redirect_uri).and_return('redirect_uri')

  stub_request(:get, "https://graph.facebook.com/oauth/access_token?client_id=app_id&client_secret=app_secret&code=#{auth_code}&redirect_uri=redirect_uri").to_return({ body: '{ "access_token": "access_token" }' })
  stub_request(:get, 'https://graph.facebook.com/me?access_token=access_token').to_return(account_response)
end
