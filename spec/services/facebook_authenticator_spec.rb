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
    let(:access_token)           { 'CAAMvEGOZAxB8BAODGpIWO9meEXEpvigfIRs5j7LIi1Uef8xvTz4vpayfP6rxn0Om3jZAmvEojZB9HNWD44PgSSwFyD7bKsJ3EaNMKwYpZBRqjm25HfwUzF3pOVRXp9cdquT1afm7bj4mnb4WFFo7TxLcgO848FaAKZBdxwefJlPneVUSpquEh2TZAVWghndnPO9ON7QTqXhAZDZD' }
    let(:response_with_fb_token) { { body: "access_token=#{access_token}&expires=5175490" } }
    let(:response_with_fb_user)  { { body: JSON.generate(facebook_data), headers: { 'Content-Type' => 'application/json' } } }
    let(:login)                  { double('login') }

    subject { described_class.new(auth_code).authenticate! }

    before do
      stub_request(:get, 'https://graph.facebook.com/oauth/access_token?client_id=app_id&client_secret=app_secret&code=authcode&redirect_uri=redirect_uri').to_return(response_with_fb_token)
      stub_request(:get, "https://graph.facebook.com/me?fields=email,name&access_token=#{access_token}").to_return(response_with_fb_user)
    end

    context 'when no login for the Facebook account exists' do
      let(:login_attributes) do
        {
          identification: facebook_data[:email],
          facebook_uid:   facebook_data[:id]
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
        allow(login).to receive(:update_attributes!).with(facebook_uid: facebook_data[:id])
      end

      it 'connects the login to the Facebook account' do
        expect(login).to receive(:update_attributes!).with(facebook_uid: facebook_data[:id])

        subject
      end
    end
  end
end
