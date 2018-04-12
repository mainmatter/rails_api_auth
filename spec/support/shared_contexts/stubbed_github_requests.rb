shared_context 'stubbed github requests' do
  let(:auth_code) { 'authcode' }
  let(:auth_state) { 'abc123' }
  let(:access_token) { 'UsQfLVVKUJmSjD6gtRk9UsrZqfpL9ajB' }
  let(:response_with_gh_token) { { body: JSON.generate({ access_token: access_token, token_type: 'bearer', scope: 'user' }), headers: { 'Content-Type' => 'application/json' } } }
  let(:response_with_gh_user)  { { body: JSON.generate(authenticated_user_data), headers: { 'Content-Type' => 'application/json' } } }
  let(:token_parameters) { { code: auth_code, client_id: 'app_id', client_secret: 'app_secret', redirect_uri: 'redirect_uri', state: auth_state } }

  before do
    stub_request(:post, GithubAuthenticator::TOKEN_URL % token_parameters).to_return(response_with_gh_token)
    stub_request(:get, GithubAuthenticator::USER_URL % { access_token: access_token }).to_return(response_with_gh_user)
  end
end
