require 'spec_helper'

describe ContactsController do

  let(:user) { FactoryGirl.create(:user, name: "freddy_2", email: "freddy_2@hawai.com", password: "freddyisin") }

  before(:each) do
    @contact = user.contacts.build(name: "Contact Freddy 2")

    #Must save the contact to test all actions except new and create, since the controller only allows access to the other actions when the user is logged in and has at least one contact.
    @contact.save
    log_in(user)
  end

  describe "GET 'new'" do
    before do
      get 'new'
    end

    it "should assign new Contact object" do
      assigns[:contact].should_not be_nil
      assigns[:contact].should be_new_record
      assigns[:contact].should be_kind_of(Contact)
    end
  end

  describe "GET 'index'" do
    before do
      get 'index'
    end

    it 'should load all contacts for the current user' do
      assigns[:contacts].should == [@contact]
    end
  end

  describe "GET 'show'" do
    it "should get the specified contact for the current user" do
      get 'show', id: @contact.id
      assigns[:contact].should == @contact
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      get 'edit', id: @contact.id
    end
    it "renders the specified contact for editing" do
      assigns[:contact].should == @contact
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
      before do
        @contact_new = {name: "Kenny Contact"}
        post :create, contact: @contact_new
      end

      it "should redirect to 'show'" do
        response.should redirect_to(contacts_path)
      end
      it "assigns contact instance variable" do
        assigns[:contact].should_not be_nil
        assigns[:contact].should be_kind_of(Contact)
      end
      it "creates a record" do
        lambda {
          post :create, contact: @contact_new
        }.should change(Contact, :count).by(1)
      end
    end

    context "when creation fails" do
      before do
        @contact_new = {name: " "}
        post :create, contact: @contact_new
      end

      it "should render 'new'" do
        response.should render_template("contacts/new")
      end
      it "should not create a record" do
        assigns[:contact].should be_new_record
        lambda {
          post :create, contact: @contact_new
        }.should change(Contact, :count).by(0)
      end
      it 'assigns the contact' do
        # This is important, so that when re-rendering "new", the previously entered values are already set
        post :create, :contact => @contact_new
        assigns[:contact].should_not be_nil
        assigns[:contact].should be_kind_of(Contact)
      end
    end
  end

  describe "PUT 'update'" do
    before do
      put 'update', id: @contact.id
    end

    context "when using a GET verb" do
      it 'rejects the request' do
        get :update, id: @contact.id
        controller.should_not_receive(:update)
      end
    end
    context "when update succeeds" do
      it "should redirect to 'show'" do
        response.should redirect_to(redirect_to contacts_url)
      end
      it "should assign person instance variable" do
        assigns[:contact].should == @contact
        assigns[:contact].should be_kind_of(Contact)
      end
      it "should update the record" do
        lambda {
          put :update, :id => @contact.to_param, :contact => {name: "BarryContact"}
        }.should change {@contact.reload.name}.from("Contact Freddy 2").to("BarryContact")
      end
    end

    context "when the update fails" do
      it "should render 'edit'" do
        put :update, :id => @contact.to_param, :contact => {name: ""}
        response.should render_template("contacts/edit")
      end
      it "should not change the record" do
        lambda {
          put :update, :id => @contact.to_param, :contact => {name: ""}
        }.should_not change {@contact.reload.name}.from("Contact Freddy 2").to("")
      end
      it 'assigns the person' do
        # This is important, so that when re-rendering "edit", the previously entered values are already set
        put :update, :id => @contact.to_param, :contact => {name: ""}
        assigns[:contact].should == @contact
      end
    end
  end

end
