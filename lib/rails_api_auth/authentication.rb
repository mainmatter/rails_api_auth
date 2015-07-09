module RailsApiAuth

  module Authentication

    extend ActiveSupport::Concern

    included do
      attr_reader :current_user

      rescue_from RequestForbidden, with: :deny_access

      private

        def deny_access
          head 403
        end

        def authenticate!
          auth_header = request.headers[:authorization]
          token = auth_header ? auth_header.split(' ').last : ''
          @current_user ||= Login.find_by!(oauth2_token: token).user

        rescue ActiveRecord::RecordNotFound
          head 401
        end
    end

  end

end
