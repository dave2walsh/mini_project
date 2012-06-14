
class SessionsController < ApplicationController
  def new
    
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      login user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid Login'
      render 'new'
    end
  end

  def destroy
  end
end
