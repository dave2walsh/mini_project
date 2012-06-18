require 'spec_helper'

describe Contact do
  let(:user) { FactoryGirl.create(:user) }
  before { @contact = user.contacts.build(name: "Contact Joe") }

  subject {@contact}

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @contact.user_id = nil }
    it { should_not be_valid }
  end

  describe "with a blank name" do
    before { @contact.name = " " }
    it { should_not be_valid }
  end

  describe "with a name that is too long" do
    before { @contact.name = "z" * 41 }
    it { should_not be_valid }
  end

  describe "association with users" do
    it { should belong_to(:user) }
  end

  describe "a contact should save correctly" do
		specify { @contact.save.should be_true}
	end

end
