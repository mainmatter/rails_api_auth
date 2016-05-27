shared_context 'oauth2 edx shared contexts' do
  let(:params) { { username: username, grant_type: grant_type, auth_code: 'authcode' } }
  let(:access_token) { 'access_token' }
  let(:email) { login.identification }

  context 'when a login with for the service account exists' do
    it 'connects the login to the service account' do
      subject
      expect(login.reload.uid).to eq(authenticated_user_data[uid_mapped_field.to_sym])
    end

    it 'responds with status 200' do
      subject

      expect(response).to have_http_status(200)
    end

    it "responds with the login's OAuth 2.0 token" do
      subject
      expect(response.body).to be_json_eql({ access_token: login.oauth2_token }.to_json)
    end
  end

  context 'when no login for the service account exists' do
    let(:email) { Faker::Internet.email }

    it 'responds with status 200' do
      subject
      expect(response).to have_http_status(200)
    end

    it 'creates a login for the service account' do
      expect { subject }.to change { Login.where(identification: email).count }.by(1)
    end

    it "responds with the login's OAuth 2.0 token" do
      subject
      login = Login.where(identification: email).first

      expect(response.body).to be_json_eql({ access_token: login.oauth2_token }.to_json)
    end
  end

  context 'when no service auth code is sent' do
    let(:params) { { grant_type: grant_type } }

    it 'responds with status 400' do
      subject

      expect(response).to have_http_status(400)
    end

    it 'responds with a "no_authorization_code" error' do
      subject

      expect(response.body).to be_json_eql({ error: 'no_authorization_code' }.to_json)
    end
  end

  context 'when no username is sent' do
    let(:params) { { auth_code: 'auth_code', grant_type: grant_type } }

    it 'responds with status 400' do
      subject

      expect(response).to have_http_status(400)
    end

    it 'responds with a "no_username" error' do
      subject

      expect(response.body).to be_json_eql({ error: 'no_username' }.to_json)
    end
  end

  context 'when service responds with an error' do
    before do
      stub_request(:get, profile_url % { username: 'user', access_token: access_token }).to_return(status: 422)
    end

    it 'responds with status 502' do
      subject

      expect(response).to have_http_status(502)
    end

    it 'responds with an empty response body' do
      subject

      expect(response.body.strip).to eql('')
    end
  end
end
