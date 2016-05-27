describe GoogleAuthenticator do
  let(:uid_mapped_field) { 'sub' }

  let(:authenticated_user_data) do
    {
      email: 'user@gmail.com',
      sub: '789789789789'
    }
  end

  subject { GoogleAuthenticator.new(auth_code).authenticate! }

  include_context 'stubbed google requests'
  it_behaves_like 'an authenticator'
end
