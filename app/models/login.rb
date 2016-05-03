# The `Login` __model encapsulates login credentials and the associated Bearer
# tokens__. Rails API Auth uses this separate model so that login data and
# user/profile data doesn't get mixed up and the Engine remains clearly
# separeated from the code of the host application.
#
# The __`Login` model has `identification` and `password` attributes__ (in fact
# it uses Rails'
# [`has_secure_password`](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password))
# __as well as a `uid`__ (a Facebook uid or Google sub)
# attribute. As opposed to the standard `has_secure_password` behavior it
# doesn't validate that the password must be present but instead validates that
# __either__ the `password` or the `uid` are present as no password is
# required in the case that Facebook or Google is used for authentication.
#
# The `Login` model also stores the Bearer token in the `oauth2_token`
# attribute. The model also stores an additional Bearer token, the
# `single_use_oauth2_token`, that can be used for implementing things like
# password reset where you need to make sure that the provided token can only
# be used once.
class Login < ActiveRecord::Base

  # This is raised when an invalid token or a token that has already been
  # consumed is consumed.
  class InvalidOAuth2Token < StandardError; end

  if RailsApiAuth.user_model_relation
    belongs_to RailsApiAuth.user_model_relation, foreign_key: :user_id
  end

  if Rails::VERSION::MAJOR >= 4
    has_secure_password validations: false
  else
    has_secure_password
  end

  validates :identification, presence: true, uniqueness: true
  validates :oauth2_token, presence: true, uniqueness: true
  validates :single_use_oauth2_token, presence: true, uniqueness: true
  validates :password, length: { maximum: 72 }, confirmation: true
  validate :password_or_uid_present

  before_validation :ensure_oauth2_token
  before_validation :assign_single_use_oauth2_token

  # Refreshes the random token. This will effectively log out all clients that
  # possess the previous token.
  #
  # @raise [ActiveRecord::RecordInvalid] if the model is invalid
  def refresh_oauth2_token!
    ensure_oauth2_token(true)
    save!
  end

  # Refreshes the single use Oauth 2.0 token.
  #
  # @raise [ActiveRecord::RecordInvalid] if the model is invalid
  def refresh_single_use_oauth2_token!
    assign_single_use_oauth2_token
    save!
  end

  if Rails::VERSION::MAJOR == 3
    # @!visibility private
    def errors
      super.tap do |errors|
        errors.delete(:password_digest)
      end
    end
  end

  private

    def password_or_uid_present
      if password_digest.blank? && uid.blank?
        errors.add :base, 'either password_digest or uid must be present'
      end
    end

    def ensure_oauth2_token(force = false)
      set_token = oauth2_token.blank? || force
      self.oauth2_token = generate_token if set_token
    end

    def assign_single_use_oauth2_token
      self.single_use_oauth2_token = generate_token
    end

    def generate_token
      SecureRandom.hex(125)
    end

end
