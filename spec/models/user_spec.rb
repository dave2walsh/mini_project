# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#

require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Big Daddy", email: "daddy@contacts.com", password: "wantin", password_confirmation: "wantin")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:contacts) }

  it { should be_valid }

  describe "when name is absent" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is absent" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name has too many characters" do
    before { @user.name = "z" * 41 }
    it { should_not be_valid }
  end

  describe "when email format is not valid" do
    invalid_addresses =  %w[dada@foo,com mama.net papa.user@foo.]
    invalid_addresses.each do |invalid_address|
      before { @user.email = invalid_address }
      it { should_not be_valid }
    end
  end

  describe "when email format is valid" do
    valid_addresses = %w[dada@foo.com mama@f.b.org papa.lst@foo.jp]
    valid_addresses.each do |valid_address|
      before { @user.email = valid_address }
      it { should be_valid }
    end
  end

  describe "when email address already exists" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when password is absent" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password and password_confirmation do not match" do
    before { @user.password_confirmation = "no_match" }
    it { should_not be_valid }
  end

  describe "when the password is too short" do
    before { @user.password = @user.password_confirmation = "z" * 5 }
    it { should be_invalid }
  end

  describe "value returned by the authenticate method" do
    before { @user.save }
    let(:user_found) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == user_found.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_with_invalid_password) { user_found.authenticate("invalid") }

      it { should_not == user_with_invalid_password }
      specify { user_with_invalid_password.should be_false }
    end
  end

  describe "a user should save correctly" do
		specify { @user.save.should be_true}
	end

  describe "remember the token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "association with contacts" do
    it { should have_many(:contacts) }
  end

end
