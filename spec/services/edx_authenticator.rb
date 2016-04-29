describe EdxAuthenticator do
  let(:uid_mapped_field) { 'sub' }

  let(:authenticated_user_data) do
    {
      email: 'user@gmail.com',
      sub: 'user'
    }
  end
  include_context 'stubbed edx requests'
  it_behaves_like 'a authenticator'
end
