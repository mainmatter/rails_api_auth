describe EdxAuthenticator do
  let(:uid_mapped_field) { 'username' }

  let(:authenticated_user_data) do
    {
      email: 'user@edxdomain.org',
      username: 'user'
    }
  end

  subject { EdxAuthenticator.new(username, auth_code).authenticate! }

  include_context 'stubbed edx requests'
  it_behaves_like 'an authenticator'
end
