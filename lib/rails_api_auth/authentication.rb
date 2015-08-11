module RailsApiAuth

  # Module that defines attributes and method for use in controllers. This
  # module would typically be included in the `ApplicationController`.
  module Authentication

    extend ActiveSupport::Concern

    # @!attribute [r] current_login
    # The login that was authenticated from the Bearer token in the
    # `Authorization` header (if one was successfully authenticated).

    # @!method authenticate!(&block)
    # Ensures that the `Authorization` header is present with a valid Bearer
    # token.
    #
    # If a valid bearer token is present this method will retrieve the
    # respective `Login` model and store it in `current_login`. If no or an
    # invalid Bearer token is present this will result in a 401 response.
    #
    # This method will typically be called as a `before_action`:
    #
    # ```ruby
    # class AuthenticatedController < ApplicationController
    #
    #   include RailsApiAuth::Authentication
    #
    #   before_filter :authenticate!
    #
    #   def index
    #     render text: 'zuper content', status: 200
    #   end
    #
    # end
    # ```
    #
    # You can also call this method with a block to perform additional checks
    # on the login retrieved for the Bearer token. When the block returns a
    # truthy value authentication is successful, when the block returns a falsy
    # value the client will see a 401 response:
    #
    # ```ruby
    # class AuthenticatedController < ApplicationController
    #
    #   include RailsApiAuth::Authentication
    #
    #   before_filter :authenticate_admin!
    #
    #   def index
    #     render text: 'zuper content', status: 200
    #   end
    #
    #   private
    #
    #     def authenticate_with_account!
    #       authenticate! do
    #         current_login.account.first_name == 'user x'
    #       end
    #     end
    #
    # end
    # ```
    #
    # @see #current_login

    # @!method consume_single_use_oauth2_token!
    # Ensures that the `Authorization` header is present with a valid
    # single-use Bearer token.
    #
    # If a valid bearer token is present this method will retrieve the
    # respective `Login` model and store it in `current_login`. If no or an
    # invalid Bearer token is present this will result in a 401 response. This
    # will also changes the `Login`'s single use OAuth 2.0 token so that the
    # same one cannot be used again. This authentication mechanism is generally
    # useful for implementing e.g. password change functionality.
    #
    # This method will typically be called as a `before_action`:
    #
    # ```ruby
    # class AuthenticatedController < ApplicationController
    #
    #   include RailsApiAuth::Authentication
    #
    #   before_filter :consume_single_use_oauth2_token!
    #
    #   def change_password
    #     ...
    #   end
    #
    # end
    # ```

    included do
      attr_reader :current_login

      private

        def authenticate!(&block)
          @current_login = Login.where(oauth2_token: bearer_token).first!

          if block_given?
            head 401 unless block.call
          else
            @current_login
          end
        rescue ActiveRecord::RecordNotFound
          head 401
        end

        def consume_single_use_oauth2_token!
          @current_login = Login.where(single_use_oauth2_token: bearer_token).first!
          @current_login.refresh_single_use_oauth2_token!
        rescue ActiveRecord::RecordNotFound
          head 401
        end

        def bearer_token
          auth_header = request.headers['Authorization']
          auth_header ? auth_header.split(' ').last : nil
        end
    end

  end

end
