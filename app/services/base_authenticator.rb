class BaseAuthenticator

  class ApiError < StandardError; end

  def initialize(auth_code)
    @auth_code = auth_code
  end

end
