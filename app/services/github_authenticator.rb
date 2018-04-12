require 'httparty'

# Handles Github authentication
#
# @!visibility private
class GithubAuthenticator < BaseAuthenticator

  PROVIDER = 'github'.freeze
  TOKEN_URL = 'https://github.com/login/oauth/access_token'.freeze
  USER_URL = 'https://api.github.com/user?access_token=%{access_token}'.freeze

  def initialize(auth_state, auth_code)
    @auth_code = auth_code
    @auth_state = auth_state
  end

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
      response = HTTParty.post(TOKEN_URL, token_options)
      response.parsed_response['access_token']
    end

    def get_user(access_token)
      @github_user ||= begin
        get_request(user_url(access_token)).parsed_response.symbolize_keys
      end
    end

    def user_url(access_token)
      USER_URL % { access_token: access_token }
    end

    def token_options
      @token_options ||= {
        headers: {
          Accept: 'application/json'
        },
        body: {
          code: @auth_code,
          client_id: RailsApiAuth.github_client_id,
          client_secret: RailsApiAuth.github_client_secret,
          redirect_uri: RailsApiAuth.github_redirect_uri,
          state: @auth_state
        }
      }
    end

end
