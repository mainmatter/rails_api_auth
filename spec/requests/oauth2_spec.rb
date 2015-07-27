describe 'Oauth2 API' do

  let!(:login) { create(:login) }

  describe 'POST /token' do
    let(:params) { { grant_type: 'password', username: login.email, password: login.password } }

    subject { post '/token', params }

    context 'for grant_type "password"' do
      context 'with valid login credentials' do
        it 'responds with status 200' do
          subject

          expect(response).to have_http_status(200)
        end

        it 'responds with an access token' do
          subject

          expect(response.body).to be_json_eql({ access_token: login.oauth2_token }.to_json)
        end
      end

      context 'with invalid login credentials' do
        let(:params) { { grant_type: 'password', username: 'bad@email.com', password: 'badpassword' } }

        it 'responds with status 400' do
          subject

          expect(response).to have_http_status(400)
        end

        it 'responds with an invalid grant error' do
          subject

          expect(response.body).to be_json_eql({ error: 'invalid_grant' }.to_json)
        end
      end
    end

    context 'for grant_type "facebook_auth_code"' do
      let(:secret)                { described_class::FB_APP_SECRET }
      let(:params)                { { grant_type: 'facebook_auth_code', auth_code: 'authcode' } }
      let(:facebook_email)        { login.email }
      let(:facebook_data)   do
        {
          id:         '1238190321',
          email:      facebook_email
        }
      end

      before do
        stub_request(:get, 'https://graph.facebook.com/oauth/access_token?client_id=app_id&client_secret=app_secret&code=authcode&redirect_uri=redirect_uri').to_return({ body: '{ "access_token": "access_token" }' })
        stub_request(:get, 'https://graph.facebook.com/me?access_token=access_token').to_return({ body: JSON.generate(facebook_data), headers: { 'Content-Type' => 'application/json' } })
      end

      context 'when a login with for the Facebook account exists' do
        it 'connects the login to the Facebook account' do
          subject

          expect(login.reload.facebook_uid).to eq(facebook_data[:id])
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

      context 'when no login for the Facebook account exists' do
        let(:facebook_email) { Faker::Internet.email }

        it 'responds with status 200' do
          subject

          expect(response).to have_http_status(200)
        end

        it 'creates a login for the Facebook account' do
          expect { subject }.to change { Login.where(email: facebook_email).count }.by(1)
        end

        it "responds with the login's OAuth 2.0 token" do
          subject
          login = Login.find_by(email: facebook_email)

          expect(response.body).to be_json_eql({ access_token: login.oauth2_token }.to_json)
        end
      end

      context 'when no Facebook auth code is sent' do
        let(:params) { { grant_type: 'facebook_auth_code' } }

        it 'responds with status 400' do
          subject

          expect(response).to have_http_status(400)
        end

        it 'responds with a "no_authorization_code" error' do
          subject

          expect(response.body).to be_json_eql({ error: 'no_authorization_code' }.to_json)
        end
      end

      context 'when Facebook responds with an error' do
        before do
          stub_request(:get, 'https://graph.facebook.com/me?access_token=access_token').to_return(status: 422)
        end

        it 'responds with status 502' do
          subject

          expect(response).to have_http_status(502)
        end

        it 'responds with an empty response body' do
          subject

          expect(response.body).to eql('')
        end
      end
    end

    context 'for an unknown grant type' do
      let(:params) { { grant_type: 'UNKNOWN' } }

      it 'responds with status 400' do
        subject

        expect(response).to have_http_status(400)
      end

      it 'responds with an "unsupported_grant_type" error' do
        subject

        expect(response.body).to be_json_eql({ error: 'unsupported_grant_type' }.to_json)
      end
    end
  end

  describe 'POST #destroy' do
    let(:params) { { token_type_hint: 'access_token', token: login.oauth2_token } }

    subject { post '/revoke', params }

    it 'responds with status 200' do
      subject

      expect(response).to have_http_status(200)
    end

    it "resets the login's OAuth 2.0 token" do
      expect { subject }.to change { login.reload.oauth2_token }

      subject
    end

    context 'for an invalid token' do
      let(:params) { { token_type_hint: 'access_token', token: 'badtoken' } }

      it 'responds with status 200' do
        subject

        expect(response).to have_http_status(200)
      end

      it "doesn't reset any logins' token" do
        expect_any_instance_of(LoginNotFound).to receive(:refresh_oauth2_token!)

        subject
      end
    end
  end
end
