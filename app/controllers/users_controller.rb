class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index, :show]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def new
	@user = User.new
  end
  
  def show
	@user = User.find(params[:id])
  end
  
  def index
    @users = User.paginate(page: params[:page])
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
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
	if @user.update_attributes(params[:user])
	  # handle a successful update
	  flash[:success] = "Profile updated"
      sign_in @user
	  redirect_to @user
	else
	  # handle a fail update
	  render 'edit'
	end
  end
  
  def destroy
    @user = User.find(params[:id])
	if @user.destroy
	  #handle delete successfully
	  flash[:success] = "User destroyed"
	  redirect_to users_path
	else
	  #handle delete fail
	end
  end
  
  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
	
	def correct_user
	
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
	
	def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
