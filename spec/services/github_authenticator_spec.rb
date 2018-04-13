describe GithubAuthenticator do
  let(:uid_mapped_field) { 'id' }

  let(:authenticated_user_data) do
    {
      email: 'user@gmail.com',
      id: '789789789789'
    }
  end
  include_context 'stubbed github requests'
  it_behaves_like 'a authenticator'
end
