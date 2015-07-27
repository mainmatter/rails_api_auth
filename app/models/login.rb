require 'email_validator'

class Login < ActiveRecord::Base

  class AlreadyVerifiedError < StandardError; end
  class InvalidOAuth2Token < StandardError; end

  if RailsApiAuth.user_model_relation
    belongs_to RailsApiAuth.user_model_relation, foreign_key: :user_id
  end

  if Rails::VERSION::MAJOR >= 4
    has_secure_password validations: false
  else
    has_secure_password
  end

  validates :email, presence: true, email: true
  validates :oauth2_token, presence: true
  validates :single_use_oauth2_token, presence: true
  validates :password, length: { maximum: 72 }, confirmation: true
  validate :password_or_facebook_uid_present

  before_validation :ensure_oauth2_token
  before_validation :refresh_single_use_oauth2_token

  def refresh_oauth2_token!
    ensure_oauth2_token(true)
    save!
  end

  def consume_single_use_oauth2_token!(token)
    raise InvalidOAuth2Token.new if token != single_use_oauth2_token
    refresh_single_use_oauth2_token
    save!
  end

  if Rails::VERSION::MAJOR == 3
    def errors
      super.tap do |errors|
        errors.delete(:password_digest)
      end
    end
  end

  private

    def password_or_facebook_uid_present
      if password_digest.blank? && facebook_uid.blank?
        errors.add :base, 'either password_digest or facebook_uid must be present'
      end
    end

    def ensure_oauth2_token(force = false)
      set_token = oauth2_token.blank? || force
      self.oauth2_token = SecureRandom.hex(125) if set_token
    end

    def refresh_single_use_oauth2_token
      self.single_use_oauth2_token = SecureRandom.hex(125)
    end

end
