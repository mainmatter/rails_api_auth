require 'rails_api_auth/engine'

# The engine's main module.
module RailsApiAuth

  # @!attribute [rw] user_model_relation
  # Defines the `Login` model's `belongs_to` relation to the host application's
  # `User` model (or `Account` or whatever the application stores user data
  # in).
  #
  # E.g. is this is set to `:profile`, the `Login` model will have a
  # `belongs_to :profile` relation.
  mattr_accessor :user_model_relation

  # @!attribute [rw] facebook_app_id
  # The Facebook App ID.
  mattr_accessor :facebook_app_id

  # @!attribute [rw] force_ssl
  # Force SSL for Oauth2Controller.
  mattr_accessor :force_ssl

  # @!attribute [rw] facebook_app_secret
  # The Facebook App secret.
  mattr_accessor :facebook_app_secret

  # @!attribute [rw] facebook_redirect_uri
  # The Facebook App's redirect URI.
  mattr_accessor :facebook_redirect_uri

  # @!attribute [rw] google_client_id
  # The Google client ID.
  mattr_accessor :google_client_id

  # @!attribute [rw] google_client_secret
  # The Google client secret.
  mattr_accessor :google_client_secret

  # @!attribute [rw] google_redirect_uri
  # The Google App's redirect URI.
  mattr_accessor :google_redirect_uri

  # @!attribute [rw] primary_key_type
  # Configures database column type used for primary keys,
  # currently only accepts :uuid
  mattr_accessor :primary_key_type

end
