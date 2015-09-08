shared_context 'stubbed facebook requests' do
  let(:auth_code) { 'authcode' }
  let(:access_token)           { 'CAAMvEGOZAxB8BAODGpIWO9meEXEpvigfIRs5j7LIi1Uef8xvTz4vpayfP6rxn0Om3jZAmvEojZB9HNWD44PgSSwFyD7bKsJ3EaNMKwYpZBRqjm25HfwUzF3pOVRXp9cdquT1afm7bj4mnb4WFFo7TxLcgO848FaAKZBdxwefJlPneVUSpquEh2TZAVWghndnPO9ON7QTqXhAZDZD' }
  let(:response_with_fb_token) { { body: "access_token=#{access_token}&expires=5175490" } }
  let(:response_with_fb_user)  { { body: JSON.generate(facebook_data), headers: { 'Content-Type' => 'application/json' } } }

  before do
    stub_request(:get, 'https://graph.facebook.com/oauth/access_token?client_id=app_id&client_secret=app_secret&code=authcode&redirect_uri=redirect_uri').to_return(response_with_fb_token)
    stub_request(:get, "https://graph.facebook.com/me?fields=email,name&access_token=#{access_token}").to_return(response_with_fb_user)
  end
end
