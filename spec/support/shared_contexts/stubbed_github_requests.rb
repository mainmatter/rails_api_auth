shared_context 'stubbed github requests' do
  let(:auth_code) { 'authcode' }
  let(:auth_state) { 'abc123' }
  let(:response_with_token) { { body: '{ "access_token": "access_token" },  "token_type": "Bearer", "expires_in": 3600' } }
  let(:response_with_user)  { { body: JSON.generate(authenticated_user_data), headers: { 'Content-Type' => 'application/json' } } }

  before do
    stub_request(:post, GithubAuthenticator::TOKEN_URL).to_return(response_with_token)
    stub_request(:get, GithubAuthenticator::USER_URL % { access_token: 'access_token' }).to_return(response_with_user)
  end
end
