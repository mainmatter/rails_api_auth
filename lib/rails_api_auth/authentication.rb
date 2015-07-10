module RailsApiAuth

  module Authentication

    class RequestForbidden < StandardError; end

    extend ActiveSupport::Concern

    included do
      attr_reader :current_login

      rescue_from RequestForbidden, with: :deny_access

      private

        def deny_access
          head 403
        end

        def authenticate!
          auth_header = request.headers[:authorization]
          token = auth_header ? auth_header.split(' ').last : ''
          @current_login ||= Login.find_by!(oauth2_token: token)

        rescue ActiveRecord::RecordNotFound
          head 401
        end
    end

  end

end
