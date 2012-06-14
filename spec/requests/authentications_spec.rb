require 'spec_helper'

describe "Authentications" do
  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_selector('h1',    text: 'Login') }
    it { should have_selector('title', text: 'Daddies Login Page') }
  end

  describe "signin" do
    before { visit login_path }

    describe "with invalid data" do
      it "should not login the user" do
        fill_in "session_email",    with: "goodman"
        fill_in "session_password",    with: "***"

        click_button "Login"
        should have_selector('div.flash_error', text: 'Invalid Login')
      end
    end
  end
end
