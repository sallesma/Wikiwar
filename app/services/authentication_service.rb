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

  def update_password(user, params)
    user.update_attributes(params)
    user.password = user.new_password

    if user.valid?
      user.save
    else
      false
    end
  end
end