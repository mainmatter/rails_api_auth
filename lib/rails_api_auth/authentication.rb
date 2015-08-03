module RailsApiAuth

  module Authentication

    extend ActiveSupport::Concern

    included do
      attr_reader :current_login

      private

        def authenticate!(&block)
          auth_header = request.headers['Authorization']
          token = auth_header ? auth_header.split(' ').last : ''
          @current_login = Login.where(oauth2_token: token).first!

          if block_given?
            head 401 unless block.call
          else
            @current_login
          end
        rescue ActiveRecord::RecordNotFound
          head 401
        end
    end

  end

end
