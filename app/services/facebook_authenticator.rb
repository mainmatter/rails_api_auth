require 'httparty'

class FacebookAuthenticator

  def initialize(auth_code)
    @auth_code = auth_code
  end

  def authenticate
    if login.present?
      connect_login_to_fb_account
    else
      create_login_from_fb_account
    end

    login
  end

  private

    def login
      @login ||= Login.find_by(email: facebook_user[:email])
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
      raise FacebookApiError.new if response.code != 200
      response
    end

    def fb_token_url
      "#{Rails.application.config.x.facebook.graph_url}/oauth/access_token".tap do |url|
        url << "?client_id=#{Rails.application.config.x.facebook.app_id}"
        url << "&redirect_uri=#{Rails.application.config.x.facebook.redirect_uri}"
        url << "&client_secret=#{Rails.application.config.x.facebook.app_secret}"
        url << "&code=#{@auth_code}"
      end
    end

    def fb_user_url(access_token)
      "#{Rails.application.config.x.facebook.graph_url}/me?access_token=#{access_token}"
    end

end
