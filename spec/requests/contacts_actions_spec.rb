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
        @contact_2 = user_2.contacts.build(name: "Contact Freddy")
        @contact_2.save
        log_in(user_2)
        visit contacts_path
      end


      it { should have_selector 'title', text: "Your Contacts Page" }

      it "should only have the current user's contacts" do
        should have_selector('td.contact_cell',    text: "#{@contact_2.name}")
        should have_selector('td.contact_cell', :count => 1)
      end
    end

  end
end
