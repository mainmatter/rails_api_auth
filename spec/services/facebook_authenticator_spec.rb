describe FacebookAuthenticator do
  let(:uid_mapped_field) { 'id' }

  let(:authenticated_user_data) do
    {
      email: 'user@facebook.com',
      id: '123123123123'
    }
  end
  include_context 'stubbed facebook requests'
  it_behaves_like 'a authenticator'
end
