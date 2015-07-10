require 'email_validator'

class Login < ActiveRecord::Base

  class AlreadyVerifiedError < StandardError; end
  class InvalidSingleUseOAuth2Token < StandardError; end

  has_secure_password validations: false

  validates :email, presence: true, email: true
  validates :oauth2_token, presence: true
  validates :single_use_oauth2_token, presence: true
  validates :password, length: { maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED }, confirmation: true
  validate :password_or_facebook_uid_present

  before_validation :ensure_oauth2_token
  before_validation :refresh_single_use_oauth2_token

  def refresh_oauth2_token!
    ensure_oauth2_token(true)
    save!
  end

  def consume_single_use_oauth2_token!(token)
    raise InvalidSingleUseOAuth2Token.new if token != single_use_oauth2_token
    refresh_single_use_oauth2_token
    save!
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
