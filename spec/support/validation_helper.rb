module ValidationHelper

	def log_in(user)
		visit login_path
		fill_in "Email",    with: user.email
		fill_in "Password", with: user.password
		click_button "Login"

		cookies[:remember_token] = user.remember_token
  end

end