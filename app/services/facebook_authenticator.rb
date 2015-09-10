require 'httparty'

# Handles Facebook authentication
#
# @!visibility private
class FacebookAuthenticator < BaseAuthenticator

  PROVIDER = 'facebook'
  TOKEN_URL = 'https://graph.facebook.com/oauth/access_token?client_id=%{client_id}&client_secret=%{client_secret}&code=%{auth_code}&redirect_uri=%{redirect_uri}'
  PROFILE_URL = 'https://graph.facebook.com/me?fields=email,name&access_token=%{access_token}'

  def authenticate!
    facebook_user = get_facebook_user(access_token)
    login         = find_login(facebook_user)

    if login.present?
      connect_login_to_fb_account(login, facebook_user)
    else
      login = create_login_from_fb_account(facebook_user)
    end

    login
  end

  private

    def find_login(facebook_user)
      Login.where(identification: facebook_user[:email]).first
    end

    def connect_login_to_fb_account(login, facebook_user)
      login.update_attributes!(uid: facebook_user[:id], provider: PROVIDER)
    end

    def create_login_from_fb_account(facebook_user)
      login_attributes = {
        identification: facebook_user[:email],
        uid: facebook_user[:id],
        provider: PROVIDER
      }

      Login.create!(login_attributes)
    end

    def access_token
      response = facebook_request(token_url).body
      response.match(/access_token=([^&]+)/)[1]
    end

    def get_facebook_user(access_token)
      @facebook_user ||= begin
        parsed_response = facebook_request(user_url(access_token)).parsed_response
        parsed_response.symbolize_keys
      end
    end

    def facebook_request(url)
      response = HTTParty.get(url)
      unless response.code == 200
        Rails.logger.warn "Facebook API request failed with status #{response.code}."
        Rails.logger.debug "Facebook API error response was:\n#{response.body}"
        raise ApiError.new
      end
      response
    end

    def token_url
      url_options = { client_id: RailsApiAuth.facebook_app_id, client_secret: RailsApiAuth.facebook_app_secret, auth_code: @auth_code, redirect_uri: RailsApiAuth.facebook_redirect_uri }
      TOKEN_URL % url_options
    end

    def user_url(access_token)
      PROFILE_URL % { access_token: access_token }
    end

end
