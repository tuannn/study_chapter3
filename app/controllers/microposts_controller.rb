class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  
  def index
  
  end
  
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
	  @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    #@micropost.destroy
    #redirect_to root_url
	@micropost = Micropost.find(params[:id])
	if @micropost.destroy
	  #handle delete successfully
	  flash[:success] = "Micropost destroyed"
	  redirect_to root_url
	else
	  #handle delete fail
	end
  end
  
  private

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_url if @micropost.nil?
    end
  
end
