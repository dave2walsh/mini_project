require 'spec_helper'

describe "ContactsActions" do

  subject { page }

  describe "access to contacts index page" do
    let(:user_1) { FactoryGirl.create(:user, name: "freddy_1", email: "freddy_1@hawai.com", password: "freddyisin") }

    before do
      visit contacts_path
    end

    it "should not allow access to users who are not logged in" do
      should_not have_selector 'title', text: "Your Contacts Page"
    end

    it "should not allow access to users who are logged in, but have no contacts" do
      log_in(user_1)
      visit contacts_path
      should have_selector 'title', text: "Create Your New Contact"
    end

    context "contacts on the page must belong to the current user" do
      let(:user_2) { FactoryGirl.create(:user, name: "freddy_2", email: "freddy_2@hawai.com", password: "freddyisin") }
      before do
        #user_2 is the current user, so user_1's contact (Contact Freddy 1) should not be on the index page when user_1 accesses that page
        @contact_1 = user_1.contacts.build(name: "Contact Freddy 1")
        @contact_2 = user_2.contacts.build(name: "Contact Freddy 2")
        @contact_3 = user_2.contacts.build(name: "Contact Freddy 3")
        @contact_1.save
        @contact_2.save
        @contact_3.save

        log_in(user_2)
        visit contacts_path
      end


      it { should have_selector 'title', text: "Your Contacts Page" }

      it "should only have the current user's contacts" do
        should_not have_selector('td.contact_cell',    text: "#{@contact_1.name}")
        should have_selector('td.contact_cell',    text: "#{@contact_2.name}")
        should have_selector('td.contact_cell',    text: "#{@contact_3.name}")
        should have_selector('td.contact_cell', :count => 2)
      end
    end
  end

  describe "creation of a new contact" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      log_in(user)
      visit new_contact_path
    end

    context "with valid data" do
      let(:contact_name) { "Carl Contact" }

      it "should create the contact" do
        fill_in "contact_name",    with: contact_name

        click_button "Create"
        should have_selector 'title', text: "Your Contacts Page"
        should have_selector('div.flash_success', text: 'You have created a new contact!')
        should have_selector('td.contact_cell',    text: "#{contact_name}")
      end
    end
    context "with invalid data" do
      it "should not create the contact" do
        fill_in "contact_name",    with: " "

        click_button "Create"
        should have_selector 'title', text: "Create Your New Contact"
      end
    end
  end

end
