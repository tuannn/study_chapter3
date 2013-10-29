class SessionsController < ApplicationController
  def new
    @user = User.new(params[:session])
	
  end
  
  def create
    user = User.find_by_email(params[:session][:email].downcase)
	
	if user && user.authenticate(params[:session][:password])
	  #login sucessfully and redirect to show user page
	  sign_in user
	  #flash[:success] = #"Welcome: " + #{user.name}#
	  redirect_to user
	else
      # Create an error message and re-render the signin form.
	  flash.now[:error] = "Email/Password is invalid"
	  render 'new'
	end
	
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
  
end
