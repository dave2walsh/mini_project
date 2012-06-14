require 'spec_helper'

describe RegistrationsController do

  describe "GET 'new'" do
    before do
      get 'new'
    end

    it "should assign new Registrant object" do
      assigns[:registrant].should_not be_nil
      assigns[:registrant].should be_new_record
      assigns[:registrant].should be_kind_of(User)
    end
  end

  describe "POST 'create'" do
    context "when using a GET verb" do
      it 'rejects the request' do
        get :create
        controller.should_not_receive(:create)
      end
    end
    context "When creation is successful" do
      it "creates a registrant" do
        @registrant_new = {name: "kenny", email: "kenny@hotmail.com", password: "kennyisin", password_confirmation: "kennyisin"}
        lambda {
          post :create, user: @registrant_new
        }.should change(User, :count).by(1)
      end
    end

    context "when creation fails" do
      before do
        @registrant_new = {name: "", email: "kenny@hotmail.com", password: "kennyisin", password_confirmation: "kennyisin"}
      end
      it "should not create a registrant" do
        lambda {
          post :create, user: @registrant_new
        }.should change(User, :count).by(0)
      end
      it 'assigns the registrant' do
        # This is important, so that when re-rendering "new", the previously entered values are already set
        post :create, :user => @registrant_new
        assigns[:registrant].should_not be_nil
        assigns[:registrant].should be_kind_of(User)
      end
    end
  end

end
