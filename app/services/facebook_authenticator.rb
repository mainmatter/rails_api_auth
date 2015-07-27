require 'httparty'

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
      @login ||= Login.where(email: facebook_user[:email]).first
    end

    def connect_login_to_fb_account
      login.update_attributes!(facebook_uid: facebook_user[:id])
    end

    def create_login_from_fb_account
      login_attributes = {
        email: facebook_user[:email],
        facebook_uid: facebook_user[:id]
      }

      @login = Login.create!(login_attributes)
    end

    def facebook_user
      @facebook_user ||= begin
        access_token = facebook_request(fb_token_url).parsed_response['access_token']
        facebook_request(fb_user_url(access_token)).parsed_response.symbolize_keys
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
      "#{RailsApiAuth.facebook_graph_url}/me?access_token=#{access_token}"
    end

end
