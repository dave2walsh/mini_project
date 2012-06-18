
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
      render 'new'
    end
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash[:success] = "You have updated your contact!"
      redirect_to contacts_url
    else
      render 'edit'
    end
  end

  #After the user is authorized he will be redirected to his intended destination, or go to the home page
  def correct_authorized_user
    @contacts = current_user.contacts
    flash[:notice] = "Please create a new contact!"
    redirect_to_target new_contact_path if @contacts.blank?
  end
end
