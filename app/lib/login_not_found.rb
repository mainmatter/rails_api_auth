# Null Object that is used when no login is found for a Bearer token.
#
# @!visibility private
class LoginNotFound

  def authenticate(_)
    false
  end

  def refresh_oauth2_token!; end

end
