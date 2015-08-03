module RailsApiAuth

  module Authentication

    extend ActiveSupport::Concern

    included do
      attr_reader :current_login

      private

        def authenticate!
          auth_header = request.headers['Authorization']
          token = auth_header ? auth_header.split(' ').last : ''
          @current_login = Login.where(oauth2_token: token).first!

        rescue ActiveRecord::RecordNotFound
          head 401
        end
    end

  end

end
