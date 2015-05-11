module AuthenticationService

  def authenticate_by_pseudo(pseudo, password)
    user = User.find_by_pseudo(pseudo)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def clear_password_reset(user)
    user.password_expires_after = nil
    user.password_reset_token = nil
  end

end