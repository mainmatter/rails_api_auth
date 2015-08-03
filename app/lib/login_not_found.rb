class LoginNotFound #:nodoc:

  def authenticate(_)
    false
  end

  def refresh_oauth2_token!; end

end
