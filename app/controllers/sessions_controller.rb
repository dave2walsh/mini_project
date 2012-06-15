
class SessionsController < ApplicationController
  def new
    
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      login user
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid Login - You will be sent to the homepage momentarily'
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
