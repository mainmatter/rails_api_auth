require 'httparty'

# Handles Facebook authentication
#
# @!visibility private
class FacebookAuthenticator

  class ApiError < StandardError; end

  def initialize(auth_code)
    @auth_code = auth_code
  end

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
      login.update_attributes!(facebook_uid: facebook_user[:id])
    end

    def create_login_from_fb_account
      login_attributes = {
        identification: facebook_user[:email],
        facebook_uid:   facebook_user[:id]
      }

      @login = Login.create!(login_attributes)
    end

    def facebook_user
      @facebook_user ||= begin
        response = facebook_request(fb_token_url).body
        access_token = response.match(/access_token=([^&]+)/)[1]
        parsed_response = facebook_request(fb_user_url(access_token)).parsed_response
        parsed_response.symbolize_keys
      end
    end

    def facebook_request(url)
      response = HTTParty.get(url)
      raise ApiError.new if response.code != 200
      response
    end

    def fb_token_url
      "#{RailsApiAuth.facebook_graph_url}/oauth/access_token".tap do |url|
        url << "?client_id=#{RailsApiAuth.facebook_app_id}"
        url << "&redirect_uri=#{RailsApiAuth.facebook_redirect_uri}"
        url << "&client_secret=#{RailsApiAuth.facebook_app_secret}"
        url << "&code=#{@auth_code}"
      end
    end

    def fb_user_url(access_token)
      "#{RailsApiAuth.facebook_graph_url}/me?fields=email,name&access_token=#{access_token}"
    end

end
