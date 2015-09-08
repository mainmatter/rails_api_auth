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
      login.update_attributes!(facebook_uid: facebook_user[:id])
    end

    def create_login_from_fb_account(facebook_user)
      login_attributes = {
        identification: facebook_user[:email],
        facebook_uid:   facebook_user[:id]
      }

      Login.create!(login_attributes)
    end

    def access_token
      response = facebook_request(fb_token_url).body
      response.match(/access_token=([^&]+)/)[1]
    end

    def get_facebook_user(access_token)
      @facebook_user ||= begin
        parsed_response = facebook_request(fb_user_url(access_token)).parsed_response
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
