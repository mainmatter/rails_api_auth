require 'httparty'

# Handles Edx authentication
#
# @!visibility private
class EdxAuthenticator < BaseAuthenticator

  PROVIDER = 'edx'.freeze
  TOKEN_URL = 'http://%{edx_domain}/oauth2/access_token'.freeze
  PROFILE_URL = 'http://%{edx_domain}/api/user/v1/accounts/%{username}'.freeze

  def initialize(username, auth_code)
    @auth_code = auth_code
    @username  = username
  end

  private

    def connect_login_to_account(login, user)
      login.update_attributes!(uid: user[:sub], provider: PROVIDER)
    end

    def create_login_from_account(user)
      login_attributes = {
        identification: user[:email],
        uid: user[:username],
        provider: PROVIDER
      }

      Login.create!(login_attributes)
    end

    def access_token
      response = HTTParty.post(TOKEN_URL % { edx_domain: RailsApiAuth.edx_domain }, token_options)
      response.parsed_response['access_token']
    end

    # Override base authenticator
    def get_request(url, headers)
      response = HTTParty.get(url, headers: headers)
      unless response.code == 200
        Rails.logger.warn "#{self.class::PROVIDER} API request failed with status #{response.code}."
        Rails.logger.debug "#{self.class::PROVIDER} API error response was:\n#{response.body}"
        raise ApiError.new
      end
      response
    end

    def get_user(access_token)
      headers = { 'Authorization' => "Bearer #{access_token}" }
      @edx_user ||= begin
        get_request(user_url, headers).parsed_response.symbolize_keys
      end
    end

    def user_url
      PROFILE_URL % { edx_domain: RailsApiAuth.edx_domain, username: @username }
    end

    def token_options
      @token_options ||= {
        body: {
          code: @auth_code,
          client_id: RailsApiAuth.edx_client_id,
          client_secret: RailsApiAuth.edx_client_secret,
          redirect_uri: RailsApiAuth.edx_redirect_uri,
          grant_type: 'authorization_code'
        }
      }
    end

end
