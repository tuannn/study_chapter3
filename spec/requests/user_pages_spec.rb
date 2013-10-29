require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
	before do
		visit signup_path 
	end
		
	let(:submit) { "Create my account" }
	
	describe "should have sign up h1 text" do	
		#it { should have_selector('h1',    text: 'Sign up') }
		#it { should have_selector('title', text: 'Sign up') }
	end
	
	describe "Submit a invalid data" do
		it "should not create a user" do
			expect { click_button submit }.not_to change(User, :count)
		end
	end
	
	describe "Submit a valid data" do
		before do
			fill_in "Name",         with: "Example User"
			fill_in "Email",        with: "user@example.com"
			fill_in "Password",     with: "foobar"
			fill_in "Confirmation", with: "foobar"
			#click_button "Create my account"
		end
		it "should create a user" do
			expect { click_button submit }.to change(User, :count).by(1)
		
		#expect do
			#click_button submit 
		#end.to change(User, :count).by(1)
		end
		
		describe "after saving the user" do
        before { click_button submit }
		  let(:user) { User.find_by_email('user@example.com') }

          it { should have_content(user.name) }
          it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        end
	
	end	
	
	describe "After submission" do
	  before { click_button submit}
	  
	  it { should have_content{'error'}}
	  it { should have_content ('Name')}
	  it { should have_content ('Email')}
	end
	
  end
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    #it { should have_selector('title', text: user.name) }
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit edit_user_path(user) }
    
	let(:changes) {"Save changes"}
    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button changes }

      it { should have_content('error') }
    end
	
	describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button changes
      end

      #it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
	
  end

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end
  end
  
end