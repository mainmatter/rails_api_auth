describe FacebookAuthenticator do
  describe '#authenticate!' do
    let(:auth_code) { 'authcode' }
    let(:email)     { 'email@facebook.com' }
    let(:facebook_data) do
      {
        id:    '1238190321',
        email: email
      }
    end
    let(:response_with_token) { { body: '{ "access_token": "access_token" }' } }
    let(:response_with_user)  { { body: JSON.generate(facebook_data), headers: { 'Content-Type' => 'application/json' } } }
    let(:login) { double('login') }

    let(:token_parameters) { { client_id: 'app_id', client_secret: 'app_secret', auth_code: auth_code, redirect_uri: 'redirect_uri' } }

    subject { described_class.new(auth_code).authenticate! }

    before do
      stub_request(:get, described_class::TOKEN_URL % token_parameters).to_return(response_with_token)
      stub_request(:get, described_class::PROFILE_URL % { access_token: 'access_token' }).to_return(response_with_user)
    end

    context 'when no login for the Facebook account exists' do
      let(:login_attributes) do
        {
          identification: facebook_data[:email],
          uid: facebook_data[:id],
          provider: 'facebook'
        }
      end

      before do
        allow(Login).to receive(:create!).with(login_attributes).and_return(login)
      end

      it 'returns a login created from the Facebook account' do
        expect(subject).to eql(login)
      end
    end

    context 'when a login for the Facebook account exists already' do
      before do
        expect(Login).to receive(:where).with(identification: facebook_data[:email]).and_return([login])
        allow(login).to receive(:update_attributes!).with(uid: facebook_data[:id], provider: 'facebook')
      end

      it 'connects the login to the Facebook account' do
        expect(login).to receive(:update_attributes!).with(uid: facebook_data[:id], provider: 'facebook')

        subject
      end
    end
  end
end
