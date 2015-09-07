require 'webmock/rspec'

describe GoogleAuthenticator do
  describe '#authenticate!' do
    let(:provider) { 'google' }
    let(:auth_code) { 'authcode' }
    let(:email)     { 'email@gmail.com' }
    let(:google_data) do
      {
        sub: '1238190321',
        email: email
      }
    end
    let(:response_with_token) { { body: '{ "access_token": "access_token" },  "token_type": "Bearer", "expires_in": 3600' } }
    let(:response_with_user)  { { body: JSON.generate(google_data), headers: { 'Content-Type' => 'application/json' } } }
    let(:login) { double('login') }

    subject { described_class.new(auth_code).authenticate! }

    before do
      stub_request(:post, 'https://www.googleapis.com/oauth2/v3/token').
        with(body: hash_including(grant_type: 'authorization_code')).to_return(body: response_with_token.to_s)
      stub_request(:get, 'https://www.googleapis.com/plus/v1/people/me/openIdConnect?access_token=access_token').to_return(response_with_user)
    end

    context 'when no login for the Google account exists' do
      let(:login_attributes) do
        {
          identification: google_data[:email],
          uid: google_data[:sub],
          provider: 'google'
        }
      end

      before do
        allow(Login).to receive(:create!).with(login_attributes).and_return(login)
      end

      it 'returns a login created from the Google account' do
        expect(subject).to eql(login)
      end
    end

    context 'when a login for the Google account exists already' do
      before do
        expect(Login).to receive(:where).with(identification: google_data[:email]).and_return([login])
        allow(login).to receive(:update_attributes!).with(uid: google_data[:sub], provider: provider)
      end

      it 'connects the login to the Google account' do
        expect(login).to receive(:update_attributes!).with(uid: google_data[:sub], provider: provider)

        subject
      end
    end
  end
end
