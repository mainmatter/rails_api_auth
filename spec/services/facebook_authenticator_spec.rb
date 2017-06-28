describe FacebookAuthenticator do
  let(:uid_mapped_field) { 'id' }

  let(:authenticated_user_data) do
    {
      email: 'user@facebook.com',
      id: '123123123123'
    }
  end

  subject { FacebookAuthenticator.new(auth_code).authenticate! }

  include_context 'stubbed facebook requests'
  it_behaves_like 'an authenticator'
end
