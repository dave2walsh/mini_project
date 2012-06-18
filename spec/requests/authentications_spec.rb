require 'spec_helper'

describe "Authentications" do
  subject { page }

  shared_examples_for "logged in user" do
    it { should have_link('Logout', href: logout_path) }
    it { should_not have_link('Login', href: login_path) }
    it { should_not have_link('Registration', href: new_user_path) }
    it { should have_link('Contacts', href: contacts_path) }
  end

  describe "login page" do
    before { visit login_path }

    it { should have_selector('h1',    text: 'Login') }
    it { should have_selector('title', text: 'Daddies Login Page') }
  end

  describe "signing in" do
    before { visit login_path }

    describe "with invalid data" do
      it { should have_link('Login', href: login_path) }

      before do
        fill_in "session_email",    with: "goodman"
        fill_in "session_password",    with: "***"
        click_button "Login"
      end

      it "should not login the user" do
        should have_selector('div.flash_error', text: 'Invalid Login - You will be sent to the homepage momentarily')
        should have_selector 'title', text: "Daddies Login Page"
        should_not have_link('Contacts', href: contacts_path)
      end

      it "should go to the homepage", js: true do
        pending("***** THE JAVASCRIPT TIMEOUT IS IGNORED IN THE TESTING FRAMEWORK, SO SKIP THIS TEST. THE JAVASCRIPT REDIRECT WORKS IN THE THIS TEST IF THE TIMEOUT IS OMITTED IN THE CODE  . *****")
        should have_selector 'title', text: "Daddies Home Page"
        should_not have_link('Contacts', href: contacts_path)
      end
    end

    describe "with valid data" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Login"
      end

      it { should have_selector 'title', text: "Daddies Home Page" }
      it_should_behave_like "logged in user"

    end
  end

  describe "signing out" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      visit root_path
      log_in(user)
    end

    it_should_behave_like "logged in user"

    it "should log out the user" do
      click_link("Logout")
      should have_link('Login', href: login_path)
      should have_selector 'title', text: "Daddies Home Page"
      should_not have_link('Contacts', href: contacts_path)
    end

  end
end
