describe 'Oauth2 API' do
  let!(:login) { create(:login) }

  describe 'POST /token with https' do
    let(:params) { { grant_type: 'password', username: login.identification, password: login.password } }
    subject { post '/token', params, 'HTTPS' => 'on' }

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
        let(:params) { { grant_type: 'password', username: login.identification, password: 'badpassword' } }

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
      let(:authenticated_user_data) do
        {
          id:    '1238190321',
          email: email
        }
      end
      let(:uid_mapped_field) { 'id' }
      let(:grant_type) { 'facebook_auth_code' }
      let(:profile_url) { FacebookAuthenticator::PROFILE_URL }
      include_context 'stubbed facebook requests'
      it_behaves_like 'oauth2 shared contexts'
    end

    context 'for grant_type "google_auth_code"' do
      let(:authenticated_user_data) do
        {
          sub: '1238190321',
          email: email
        }
      end
      let(:uid_mapped_field) { 'sub' }
      let(:grant_type) { 'google_auth_code' }
      let(:profile_url) { GoogleAuthenticator::PROFILE_URL }
      include_context 'stubbed google requests'
      it_behaves_like 'oauth2 shared contexts'
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

  describe 'POST #destroy with https' do
    let(:params) { { token_type_hint: 'access_token', token: login.oauth2_token } }
    subject { post '/revoke', params, 'HTTPS' => 'on' }

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

  describe 'force_ssl on http requests' do
    before(:all) { @orig_force_ssl = RailsApiAuth.force_ssl }
    after(:all) { RailsApiAuth.force_ssl = @orig_force_ssl }

    context 'POST /token' do
      let(:params) { { grant_type: 'password', username: login.identification, password: login.password } }
      subject { post '/token', params }

      it 'responds with status 301 when set to true' do
        RailsApiAuth.force_ssl = true
        subject
        expect(response).to have_http_status(301)
      end

      it 'responds with status 200 when set to false' do
        RailsApiAuth.force_ssl = false
        subject
        expect(response).to have_http_status(200)
      end

      it 'responds with status 200 when nil' do
        RailsApiAuth.force_ssl = nil
        subject
        expect(response).to have_http_status(200)
      end
    end

    context 'POST #destroy' do
      let(:params) { { token_type_hint: 'access_token', token: login.oauth2_token } }
      subject { post '/revoke', params }

      it 'responds with status 301 when set to true' do
        RailsApiAuth.force_ssl = true
        subject
        expect(response).to have_http_status(301)
      end

      it 'responds with status 200 when set to false' do
        RailsApiAuth.force_ssl = false
        subject
        expect(response).to have_http_status(200)
      end

      it 'responds with status 200 when nil' do
        RailsApiAuth.force_ssl = nil
        subject
        expect(response).to have_http_status(200)
      end
    end
  end
end
