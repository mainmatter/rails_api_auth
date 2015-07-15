module RailsApiAuth

  module Authentication

    extend ActiveSupport::Concern

    included do
      attr_reader :current_login

      private

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
