require 'login_not_found'

# The controller that implements the engine's endpoints.
#
# @!visibility private
class Oauth2Controller < ApplicationController

  force_ssl if: -> { RailsApiAuth.force_ssl }

  # rubocop:disable MethodLength
  def create
    case params[:grant_type]
    when 'password'
      authenticate_with_credentials(params[:username], params[:password])
    when 'facebook_auth_code'
      authenticate_with_facebook(params[:auth_code])
    when 'google_auth_code'
      authenticate_with_google(params[:auth_code])
    when 'edx_auth_code'
      authenticate_with_edx(params[:username], params[:auth_code])
    else
      oauth2_error('unsupported_grant_type')
    end
  end

  # rubocop:enable MethodLength
  def destroy
    oauth2_error('unsupported_token_type') && return unless params[:token_type_hint] == 'access_token'

    login = Login.where(oauth2_token: params[:token]).first || LoginNotFound.new
    login.refresh_oauth2_token!

    head 200
  end

  private

    def authenticate_with_credentials(identification, password)
      login = Login.where(identification: identification).first || LoginNotFound.new

      if login.authenticate(password)
        render json: { access_token: login.oauth2_token }
      else
        oauth2_error('invalid_grant')
      end
    end

    def authenticate_with_facebook(auth_code)
      oauth2_error('no_authorization_code') && return unless auth_code.present?

      login = FacebookAuthenticator.new(auth_code).authenticate!

      render json: { access_token: login.oauth2_token }
    rescue FacebookAuthenticator::ApiError
      head 502
    end

    def authenticate_with_google(auth_code)
      oauth2_error('no_authorization_code') && return unless auth_code.present?

      login = GoogleAuthenticator.new(auth_code).authenticate!

      render json: { access_token: login.oauth2_token }
    rescue GoogleAuthenticator::ApiError
      head 502
    end

    def authenticate_with_edx(username, auth_code)
      oauth2_error('no_authorization_code') && return unless auth_code.present?
      oauth2_error('no_username') && return unless username.present?

      login = EdxAuthenticator.new(username, auth_code).authenticate!

      render json: { access_token: login.oauth2_token }
    rescue EdxAuthenticator::ApiError
      head 502
    end

    def oauth2_error(error)
      render json: { error: error }, status: 400
    end

end
