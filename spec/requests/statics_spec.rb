require 'spec_helper'

describe "Statics" do
  subject { page }

  shared_examples_for "all the static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: page_title) }
    it "should go to the homepage when you click the 'Home' link" do
      click_link "Home"
      should have_selector 'title', text: "Daddies Home Page"
    end
  end

  describe "Home page" do
    before { visit root_path }

    let(:heading)    { 'Home Page' }
    let(:page_title) { 'Daddies Home Page' }

    it_should_behave_like "all the static pages"
  end
end
