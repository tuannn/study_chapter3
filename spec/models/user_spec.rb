require 'spec_helper'

describe User do
  before do 
	@user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar") 
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  
  it { should be_valid }
#  it "should respond to 'name'" do
#	@user.respond_to?(:name)
#  end
  
#  it "should respond to 'email'" do
#	@user.respond_to?(:email)
#  end
  
  describe "when name is not present" do
	before {@user = User.new(name: "", email: "user@example.com")}
	
	it { should_not be_valid }
  end  
  
  describe "when email is not present" do
	before {@user.email = ""}
	
	it { should_not be_valid }
	#@user.should_not be_valid
  end

  describe "when name is too long" do
  
	before {@user.name = "a"*51}
	
	it { should_not be_valid}
  end 
  
  describe "when email format is invaild" do
	it "should be invalid" do
		addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
		
		addresses.each do |invalid_address|
			@user.email = invalid_address
			@user.should_not be_valid
		end
	end
  end
  
  describe "when email format is valid" do
	it "should be valid" do
		addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
		
		addresses.each do |valid_address|
			@user.email = valid_address
			@user.should be_valid
		end
	end
  end
  
  describe "when email is already taken" do
	before do
		user_with_same_email = @user.dup
		user_with_same_email.email = @user.email.upcase
		user_with_same_email.save
	end
	
	it { should_not be_valid}
  end
  
  describe "when password is not present" do
	before do
		@user.password =""
	end
	it { should_not be_valid }
  end
  
  describe "when password_confirmation is not present" do
	before do
		@user.password_confirmation = ""
	end
  end
  
  describe "when password and password_confirmation is not matching" do
	before do
		@user.password_confirmation = "mismatch"
	end
	it { should_not be_valid}
  end
  
  describe "when password_confimation is nil" do
	before do
		@user.password_confirmation = nil
	end
	it { should_not be_valid }
  end
  
  describe "return value of authenticate method" do
	before do
		@user.save		
	end
	
	let(:found_user) { User.find_by_email(@user.email) }
	
	describe "with valid password" do
		it { should == found_user.authenticate(@user.password)}
	end
	
	describe "with invalid password" do
		let(:user_for_invalid_password) { found_user.authenticate("invalid") }
		it { should_not == user_for_invalid_password}
		specify { user_for_invalid_password.should be_false }
	end
	
  end
  
  describe "with a password that's too short" do
	before { @user.password = @user.password_confirmation = "a" * 5 }
	it { should_not be_valid }
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
