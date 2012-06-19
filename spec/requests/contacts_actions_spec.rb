require 'spec_helper'

describe "ContactsActions" do

  subject { page }

  let(:user_0) { FactoryGirl.create(:user, name: "freddy_0", email: "freddy_0@hawai.com", password: "freddyisin") }
  let(:user_1) { FactoryGirl.create(:user, name: "freddy_1", email: "freddy_1@hawai.com", password: "freddyisin") }
  let(:user_2) { FactoryGirl.create(:user, name: "freddy_2", email: "freddy_2@hawai.com", password: "freddyisin") }

  before do
    @contact_1 = user_1.contacts.build(name: "Contact Freddy 1")
    @contact_2 = user_2.contacts.build(name: "Contact Freddy 2_1")
    @contact_3 = user_2.contacts.build(name: "Contact Freddy 2_2")
    @contact_1.save
    @contact_2.save
    @contact_3.save
  end


  describe "access to contacts index page" do
    before do
      visit contacts_path
    end

    it "should not allow access to users who are not logged in" do
      should_not have_selector 'title', text: "Your Contacts Page"
    end

    it "should not allow access to users who are logged in, but have no contacts" do
      log_in(user_0)
      visit contacts_path
      should have_selector 'title', text: "Create Your New Contact"
    end

    context "contacts on the page must belong to the current user" do
      before do
        #user_2 is the current user, so user_1's contact (Contact Freddy 1) should not be on the index page when user_1 accesses that page
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
    before do
      log_in(user_0)
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

  describe "updating a current contact" do
    before do
      log_in(user_1)
      visit edit_contact_path(@contact_1)
    end

    it "should be on the edit page" do
      should have_selector 'title', text: "Edit Your Contact"
    end

    context "with valid data" do
      let(:contact_name) { "Carl Contact Update" }

      it "should update the contact" do
        fill_in "contact_name",    with: contact_name

        click_button "Update"
        should have_selector 'title', text: "Your Contacts Page"

        should have_selector('td.contact_cell',    text: "#{contact_name}")
      end
    end
    context "with invalid data" do
      it "should not update the contact" do
        fill_in "contact_name",    with: " "

        click_button "Update"
        should have_selector 'title', text: "Edit Your Contact"
        should have_selector('div.flash_error', text: 'Contact update has failed')
      end
    end
  end

  describe "navigating the contacts links" do
    before do
      log_in(user_1)
      visit root_path
    end

    it "should go to the new page when the 'new' link is clicked" do
      click_link "Add a New Contact"
      should have_selector 'title', text: "Create Your New Contact"
    end
    it "should go to the index page when the 'all' link is clicked" do
      click_link "Show All Your Contacts"
      should have_selector 'title', text: "Your Contacts Page"
    end

    context "check the edit links on the index page" do
      before { visit contacts_path }
      it "should go to the edit page" do
        click_link "edit"
        should have_selector 'title', text: "Edit Your Contact"
        should have_selector("input", id: "contact_name", content: "#{@contact_1.name}")
      end
    end

    context "check the delete link on the index page for a user with one contact" do
      before  do
        log_in(user_1)
        visit contacts_path
      end

      it "should delete the contact and go to the contact creation page" do
        click_link "delete"
        should have_selector 'title', text: "Create Your New Contact"
      end
    end

    context "check the delete link on the index page for a user with more than one contact" do
      before do
        log_in(user_2)
        visit contacts_path
      end

      it "should delete the contact and go to the index page" do
        click_link "delete"
        should have_selector 'title', text: "Your Contacts Page"
        should_not have_selector 'td', text: "#{@contact_2.name}"
      end
    end

  end

end
