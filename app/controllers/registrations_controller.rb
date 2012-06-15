
class RegistrationsController < ApplicationController
  def new
    @registrant = User.new
  end

  def create
    @registrant = User.new(params[:user])
    if @registrant.save
      login @registrant
      flash[:success] = "You have created a new registrant!"
      redirect_to root_url
    else
      render 'new'
    end
  end
end
