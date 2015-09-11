class BaseAuthenticator

  class ApiError < StandardError; end

  def initialize(auth_code)
    @auth_code = auth_code
  end

  def authenticate!
    user = get_user(access_token)
    login = find_login(user)

    if login.present?
      connect_login_to_account(login, user)
    else
      login = create_login_from_account(user)
    end

    login
  end

  private

    def find_login(user)
      Login.where(identification: user[:email]).first
    end

    def get_request(url)
      response = HTTParty.get(url)
      unless response.code == 200
        Rails.logger.warn "#{self.class::PROVIDER} API request failed with status #{response.code}."
        Rails.logger.debug "#{self.class::PROVIDER} API error response was:\n#{response.body}"
        raise ApiError.new
      end
      response
    end

end
