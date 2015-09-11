shared_context 'stubbed facebook requests' do
  let(:auth_code) { 'authcode' }
  let(:access_token)           { 'CAAMvEGOZAxB8BAODGpIWO9meEXEpvigfIRs5j7LIi1Uef8xvTz4vpayfP6rxn0Om3jZAmvEojZB9HNWD44PgSSwFyD7bKsJ3EaNMKwYpZBRqjm25HfwUzF3pOVRXp9cdquT1afm7bj4mnb4WFFo7TxLcgO848FaAKZBdxwefJlPneVUSpquEh2TZAVWghndnPO9ON7QTqXhAZDZD' }
  let(:response_with_fb_token) { { body: JSON.generate({ access_token: access_token, token_type: 'bearer', expires_in: 5169402 }), headers: { 'Content-Type' => 'application/json' } } }
  let(:response_with_fb_user)  { { body: JSON.generate(facebook_data), headers: { 'Content-Type' => 'application/json' } } }
  let(:token_parameters) { { client_id: 'app_id', client_secret: 'app_secret', auth_code: auth_code, redirect_uri: 'redirect_uri' } }

  before do
    stub_request(:get, FacebookAuthenticator::TOKEN_URL % token_parameters).to_return(response_with_fb_token)
    stub_request(:get, FacebookAuthenticator::PROFILE_URL % { access_token: access_token }).to_return(response_with_fb_user)
  end
end
