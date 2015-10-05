shared_context 'stubbed google requests' do
  let(:auth_code) { 'authcode' }
  let(:response_with_token) { { body: '{ "access_token": "access_token" },  "token_type": "Bearer", "expires_in": 3600' } }
  let(:response_with_user)  { { body: JSON.generate(authenticated_user_data), headers: { 'Content-Type' => 'application/json' } } }

  before do
    stub_request(:post, GoogleAuthenticator::TOKEN_URL).
      with(body: hash_including(grant_type: 'authorization_code')).to_return(response_with_token)
    stub_request(:get, GoogleAuthenticator::PROFILE_URL % { access_token: 'access_token' }).to_return(response_with_user)
  end
end
