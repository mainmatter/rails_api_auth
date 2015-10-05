describe GoogleAuthenticator do
  let(:uid_mapped_field) { 'sub' }

  let(:authenticated_user_data) do
    {
      email: 'user@gmail.com',
      sub: '789789789789'
    }
  end
  include_context 'stubbed google requests'
  it_behaves_like 'a authenticator'
end
