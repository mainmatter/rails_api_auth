require 'httparty'

# Handles Facebook authentication
#
# @!visibility private
class FacebookAuthenticator < BaseAuthenticator

  PROVIDER = 'facebook'.freeze
  TOKEN_URL = 'https://graph.facebook.com/v2.4/oauth/access_token?client_id=%{client_id}&client_secret=%{client_secret}&code=%{auth_code}&redirect_uri=%{redirect_uri}'.freeze
  PROFILE_URL = 'https://graph.facebook.com/v2.4/me?fields=email,name&access_token=%{access_token}'.freeze

  private

    def connect_login_to_account(login, user)
      login.update_attributes!(uid: user[:id], provider: PROVIDER)
    end

    def create_login_from_account(user)
      login_attributes = {
        identification: user[:email],
        uid: user[:id],
        provider: PROVIDER
      }

      Login.create!(login_attributes)
    end

    def access_token
      response = get_request(token_url)
      response.parsed_response.symbolize_keys[:access_token]
    end

    def get_user(access_token)
      @facebook_user ||= begin
        parsed_response = get_request(user_url(access_token)).parsed_response
        parsed_response.symbolize_keys
      end
    end

    def token_url
      url_options = { client_id: RailsApiAuth.facebook_app_id, client_secret: RailsApiAuth.facebook_app_secret, auth_code: @auth_code, redirect_uri: RailsApiAuth.facebook_redirect_uri }
      TOKEN_URL % url_options
    end

    def user_url(access_token)
      PROFILE_URL % { access_token: access_token }
    end

end
