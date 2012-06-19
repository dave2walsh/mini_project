
class ContactsController < ApplicationController
  before_filter :logged_in_user
  before_filter :correct_authorized_user, except: [:new, :create]

  def new
    @contact = Contact.new
  end

  def index
    @contacts = current_user.contacts
  end

  def show
    @contact  = Contact.find(params[:id])
  end

  def edit
    @contact  = Contact.find(params[:id])
  end

  def create
    @contact = current_user.contacts.build(params[:contact])
    if @contact.save
      flash[:success] = "You have created a new contact!"
      redirect_to contacts_url
    else
      flash.now[:error] = "Contact creation has failed"
      render 'new'
    end
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash[:success] = "You have successfully updated your contact!"
      redirect_to contacts_url
    else
      flash.now[:error] = "Contact update has failed"
      render 'edit'
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contacts_url
  end

  #After the user is authorized he will be redirected to his intended destination, or go to the home page
  def correct_authorized_user
    @contacts = current_user.contacts
    if(@contacts.blank?)
      flash[:notice] = "Please create a new contact!"
      redirect_to_target new_contact_path
    end
  end
end
