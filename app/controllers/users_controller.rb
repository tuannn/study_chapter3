class UsersController < ApplicationController
  def new
	@user = User.new
  end
  
  def show
	@user = User.find(params[:id])
  end
  
  def index
  
  end
  
  def create
    	@user = User.new(params[:user])
		if @user.save
		  #Handle sucessful save
		  flash[:success] = "Welcome to the Sample App!"
		  redirect_to @user
		else
		  # back to sign up page and show error
		  render 'new'
		end
  end
  
  def edit
  
  end
  
  def update
  
  end
  
  def destroy
  
  end
end
