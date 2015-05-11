module AuthenticationService

  def authenticate_by_pseudo(pseudo, password)
    user = User.find_by_pseudo(pseudo)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def set_password_reset(user)
    user.password_expires_after = 24.hours.from_now
    user.password_reset_token = SecureRandom.urlsafe_base64
    user.save
  end

  def clear_password_reset(user)
    user.password_expires_after = nil
    user.password_reset_token = nil
    user.save
  end
end