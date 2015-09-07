require 'httparty'

# Handles Facebook authentication
#
# @!visibility private
class FacebookAuthenticator < BaseAuthenticator

  PROVIDER = 'facebook'
  TOKEN_URL = 'https://graph.facebook.com/oauth/access_token?client_id=%{client_id}&client_secret=%{client_secret}&code=%{auth_code}&redirect_uri=%{redirect_uri}'
  PROFILE_URL = 'https://graph.facebook.com/me?access_token=%{access_token}'

  def authenticate!
    if login.present?
      connect_login_to_fb_account
    else
      create_login_from_fb_account
    end

    login
  end

  private

    def login
      @login ||= Login.where(identification: facebook_user[:email]).first
    end

    def connect_login_to_fb_account
      login.update_attributes!(uid: facebook_user[:id], provider: PROVIDER)
    end

    def create_login_from_fb_account
      login_attributes = {
        identification: facebook_user[:email],
        uid: facebook_user[:id],
        provider: PROVIDER
      }

      @login = Login.create!(login_attributes)
    end

    def facebook_user
      @facebook_user ||= begin
        access_token = facebook_request(token_url).parsed_response['access_token']
        facebook_request(user_url(access_token)).parsed_response.symbolize_keys
      end
    end

    def facebook_request(url)
      response = HTTParty.get(url)
      raise ApiError.new if response.code != 200
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
