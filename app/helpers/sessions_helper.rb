module SessionsHelper

  def login(user)
    cookies.permanent[:remember_token] = user.remember_token
    current_user = user
  end

  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end

  def logged_in?
    !current_user.nil?
  end
  
  def logout
    current_user = nil
    cookies.delete(:remember_token)
  end

  def logged_in_user
		unless logged_in?
			store_location
			redirect_to login_path, notice: "Please log in."
		end
  end

  #Store the user's intended path
  def store_location
    session[:return_to] = request.fullpath
  end

  #redirect the user to his intended target after authorization, or go to the default_path if session[:return_to] is nil
  def redirect_to_target(default_path)
    redirect_to(session[:return_to] || default_path)
    clear_target_path
  end

  private

  def user_from_remember_token
    remember_token = cookies[:remember_token]
    User.find_by_remember_token(remember_token) unless remember_token.nil?
  end

  #Delete the cookie that holds the user's intended path
  def clear_target_path
    session.delete(:return_to)
  end
end
