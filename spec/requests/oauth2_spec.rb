describe 'Oauth2 API' do
  let!(:login) { create(:login) }

  describe 'POST /token' do
    let(:params) { { grant_type: 'password', username: login.identification, password: login.password } }
    if Rails::VERSION::MAJOR < 5
      # rubocop:disable Rails/HttpPositionalArguments
      subject { post '/token', params, 'HTTPS' => ssl }
      # rubocop:enable Rails/HttpPositionalArguments
    else
      subject { post '/token', params: params, headers: { 'HTTPS' => ssl } }
    end

    shared_examples 'when the request gets through' do
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
        include_examples 'oauth2 shared contexts'
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
        include_examples 'oauth2 shared contexts'
      end

      context 'for grant_type "edx_auth_code"' do
        let(:authenticated_user_data) do
          {
            username: 'user',
            email: email
          }
        end
        let(:uid_mapped_field) { 'username' }
        let(:grant_type) { 'edx_auth_code' }
        let(:profile_url) { EdxAuthenticator::PROFILE_URL }

        include_context 'stubbed edx requests'
        include_examples 'oauth2 edx shared contexts'
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

    context 'when SSL is forced' do
      include_context 'with force_ssl configured'
      let(:force_ssl) { true }

      context 'and the request uses SSL' do
        let(:ssl) { 'on' }

        include_examples 'when the request gets through'
      end

      context 'and the request does not use SSL' do
        let(:ssl) { false }

        it 'responds with status 301' do
          subject

          expect(response).to have_http_status(301)
        end
      end
    end

    context 'when SSL is not forced' do
      include_context 'with force_ssl configured'
      let(:force_ssl) { false }

      context 'and the request uses SSL' do
        let(:ssl) { 'on' }

        include_examples 'when the request gets through'
      end

      context 'and the request does not use SSL' do
        let(:ssl) { false }

        include_examples 'when the request gets through'
      end
    end
  end

  describe 'POST #destroy' do
    let(:params) { { token_type_hint: 'access_token', token: login.oauth2_token } }

    if Rails::VERSION::MAJOR < 5
      # rubocop:disable Rails/HttpPositionalArguments
      subject { get '/access-once', {}, headers }
      subject { post '/revoke', params, 'HTTPS' => ssl }
      # rubocop:enable Rails/HttpPositionalArguments
    else
      subject { get '/access-once', params: {}, headers: headers }
      subject { post '/revoke', params: params, headers: { 'HTTPS' => ssl } }
    end

    shared_examples 'when the request gets through' do
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

    context 'when SSL is forced' do
      include_context 'with force_ssl configured'
      let(:force_ssl) { true }

      context 'and the request uses SSL' do
        let(:ssl) { 'on' }

        include_examples 'when the request gets through'
      end

      context 'and the request does not use SSL' do
        let(:ssl) { false }

        it 'responds with status 301' do
          subject

          expect(response).to have_http_status(301)
        end
      end
    end

    context 'when SSL is not forced' do
      include_context 'with force_ssl configured'
      let(:force_ssl) { false }

      context 'and the request uses SSL' do
        let(:ssl) { 'on' }

        include_examples 'when the request gets through'
      end

      context 'and the request does not use SSL' do
        let(:ssl) { false }

        include_examples 'when the request gets through'
      end
    end
  end
end
