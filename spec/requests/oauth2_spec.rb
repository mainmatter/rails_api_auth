describe 'Oauth2 API' do

  let!(:login) { create(:login) }

  describe 'POST /token' do
    let(:params) { { grant_type: 'password', username: login.email, password: login.password } }

    subject { post '/token', params }

    context 'for grant_type "password"' do
      context 'with valid login credentials' do
        it 'succeeds' do
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
      let(:params)                { { grant_type: 'facebook_auth_code', auth_code: 'fb auth code' } }
      let(:facebook_email)        { login.email }
      let(:facebook_data)   do
        {
          id:         '1238190321',
          email:      facebook_email
        }
      end

      before do
        stub_request(:get, %r{https://graph.facebook.com/v2.3/oauth/access_token}).to_return(body: '{ "access_token": "access_token" }')
        stub_request(:get, %r{https://graph.facebook.com/v2.3/me}).to_return(body: JSON.generate(facebook_data), headers: { 'Content-Type' => 'application/json' })
      end

      context 'when a login with the posted Facebook email exists' do
        it 'connects the login to the Facebook account' do
          subject

          expect(login.reload.facebook_uid).to eq(facebook_data[:id])
        end

        it 'succeeds' do
          subject

          expect(response).to have_http_status(200)
        end

        it 'responds with an oauth2 token' do
          subject

          expect(response.body).to be_json_eql({ access_token: login.oauth2_token }.to_json)
        end
      end

      context 'when no login with the posted Facebook email exists' do
        let(:facebook_email) { Faker::Internet.email }

        it 'succeeds' do
          subject

          expect(response).to have_http_status(200)
        end

        it 'creates a login with it' do
          expect { subject }.to change { Login.where(email: facebook_email).count }.by(1)
        end

        it 'responds with an oauth2 token' do
          subject
          login = Login.find_by(email: facebook_email)

          expect(response.body).to be_json_eql({ access_token: login.oauth2_token }.to_json)
        end
      end

      context 'when no facebook code is sent' do
        let(:params) { { grant_type: 'facebook_auth_code' } }

        it 'responds with status 400' do
          subject

          expect(response).to have_http_status(400)
        end

        it 'responds with a no authorization code error' do
          subject

          expect(response.body).to be_json_eql({ error: 'no_authorization_code' }.to_json)
        end
      end

      context 'when Facebook responds with an error' do
        before do
          stub_request(:get, %r{https://graph.facebook.com/v2.3/oauth/access_token}).to_return(status: 422)
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

      it 'responds with an invalid grant error' do
        subject

        expect(response.body).to be_json_eql({ error: 'unsupported_grant_type' }.to_json)
      end
    end
  end

  describe 'POST #destroy' do
    let(:params) { { token_type_hint: 'access_token', token: login.oauth2_token } }

    subject { post '/revoke', params }

    it 'succeeds' do
      subject

      expect(response).to have_http_status(200)
    end

    it 'resets login token' do
      expect { subject }.to change { login.reload.oauth2_token }

      subject
    end

    context 'for an unknown (or stale) token' do
      let(:params) { { token_type_hint: 'access_token', token: 'badtoken' } }

      it 'succeeds' do
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
