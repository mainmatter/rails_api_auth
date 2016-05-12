describe EdxAuthenticator do
  let(:uid_mapped_field) { 'username' }

  let(:authenticated_user_data) do
    {
      email: 'user@edxdomain.org',
      username: 'user'
    }
  end
  include_context 'stubbed edx requests'
  it_behaves_like 'a authenticator'
end
