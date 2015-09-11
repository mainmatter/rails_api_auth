require 'httparty'

# Handles Google authentication
#
# @!visibility private
class GoogleAuthenticator < BaseAuthenticator

  PROVIDER = 'google'
  TOKEN_URL = 'https://www.googleapis.com/oauth2/v3/token'
  PROFILE_URL = 'https://www.googleapis.com/plus/v1/people/me/openIdConnect?access_token=%{access_token}'

  private

    def connect_login_to_account(login, user)
      login.update_attributes!(uid: user[:sub], provider: PROVIDER)
    end

    def create_login_from_account(user)
      login_attributes = {
        identification: user[:email],
        uid: user[:sub],
        provider: PROVIDER
      }

      Login.create!(login_attributes)
    end

    def access_token
      response = HTTParty.post(TOKEN_URL, token_options)
      response.parsed_response['access_token']
    end

    def get_user(access_token)
      @google_user ||= begin
        get_request(user_url(access_token)).parsed_response.symbolize_keys
      end
    end

    def user_url(access_token)
      PROFILE_URL % { access_token: access_token }
    end

    def token_options
      @token_options ||= {
        body: {
          code: @auth_code,
          client_id: RailsApiAuth.google_client_id,
          client_secret: RailsApiAuth.google_client_secret,
          redirect_uri: RailsApiAuth.google_redirect_uri,
          grant_type: 'authorization_code'
        }
      }
    end

end
