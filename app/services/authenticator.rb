class Authenticator
  def self.authenticate params
    if params[:google_access_token].present?
      authenticate_with_google params[:google_access_token]
    else
      authenticate_with_email params[:email], params[:password]
    end
  end

  def self.authenticate_with_google token
    login = GoogleLogin.new(token)
    if login.run
      user = User.find_or_initialize_by(email: login.result[:email])
      user.update_attributes(name: login.result[:name], password: SecureRandom.hex(8)) unless user.persisted?
      return user
    else
      raise AuthenticationError.new('Invalid google access token')
    end
  end

  def self.authenticate_with_email email, password
    user = User.find_by_email(email)
    return user if (user.present? && user.valid_password?(password))
    raise AuthenticationError.new("Invalid email/password")
  end
  class AuthenticationError < StandardError; end
end
