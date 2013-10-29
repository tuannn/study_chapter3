require 'spec_helper'

describe "Authentication" do

  subject { page }
  let(:signin) {"Sign in"}	
  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    #it { should have_selector('title', text: 'Sign in') }
	
	describe "when user or password dose not match" do
	  before {click_button signin}
	  
	  it {should have_content("Invalid")}
	end
	
	describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button signin
      end

      #it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
	
	describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
  end
end