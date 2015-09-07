require 'httparty'

# Handles Google authentication
#
# @!visibility private
class GoogleAuthenticator

  PROVIDER = 'google'
  TOKEN_URL = 'https://www.googleapis.com/oauth2/v3/token'
  PROFILE_URL = 'https://www.googleapis.com/plus/v1/people/me/openIdConnect?access_token='

  class ApiError < StandardError; end

  def initialize(auth_code)
    @auth_code = auth_code
  end

  def authenticate!
    if login.present?
      connect_login_to_google_account
    else
      create_login_from_google_account
    end

    login
  end

  private

  def login
    @login ||= Login.where(identification: google_user[:email]).first
  end

  def connect_login_to_google_account
    login.update_attributes!(uid: google_user[:sub], provider: PROVIDER)
  end

  def create_login_from_google_account
    login_attributes = {
      identification: google_user[:email],
      uid: google_user[:sub],
      provider: PROVIDER
    }

    @login = Login.create!(login_attributes)
  end

  def google_user
    @google_user ||= begin
      get_request(user_url(access_token)).parsed_response.symbolize_keys
    end
  end

  def get_request(url)
    response = HTTParty.get(url)
    raise ApiError.new if response.code != 200
    response
  end

  def user_url(access_token)
    "#{PROFILE_URL}#{access_token}"
  end

  def access_token
    options = {
      body: {
        code: @auth_code,
        client_id: RailsApiAuth.google_client_id,
        client_secret: RailsApiAuth.google_client_secret,
        redirect_uri: RailsApiAuth.google_redirect_uri,
        grant_type: 'authorization_code'
      }
    }
    response = HTTParty.post(TOKEN_URL, options)
    response.parsed_response['access_token']
  end

end
