require 'spec_helper'

describe "Registrations" do
  subject { page }

  describe "for unregistered users on the home page" do
    before { visit root_path }
    it "should go to the registrations page when you click the 'Registration' link" do
      click_link "Registration"
      page.should have_selector 'title', text: "Daddies New Registration Page"
    end

    describe "creating a new registrant" do
      before(:each) { visit new_user_path }

      context "saving a registrant with valid name, email and password data" do
        it "should create the registrant" do
          fill_in "user_name",    with: "goodman"
          fill_in "user_email",    with: "goodman@happy.com"
          fill_in "user_password",    with: "goodmanisin"
          fill_in "user_password_confirmation",    with: "goodmanisin"

          click_button "Create"
          page.should have_selector 'title', text: "Daddies Home Page"
          page.should have_link('Logout', href: logout_path)
          page.should_not have_link('Login', href: login_path)
          page.should_not have_link('Registration', href: new_user_path)
          should have_selector('div.flash_success', text: 'You have created a new registrant!')
        end
      end

      context "saving a registrant with invalid data" do
        it "should not create the registrant" do
          fill_in "user_name",    with: " "
          fill_in "user_email",    with: "goodman@happy.com"
          fill_in "user_password",    with: "goodmanisin"
          fill_in "user_password_confirmation",    with: "goodmanisin"

          click_button "Create"
          page.should have_selector 'title', text: "Daddies New Registration Page"
        end
      end

    end
  end
end
