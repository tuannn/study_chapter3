class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
    #@micropost = current_user.microposts.build if signed_in?
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
  def signin
    @user = User.new
  end
  
  def search
    @users = User.name_search(params[:search])
	#@users_found = @user_found.paginate(page: params[:page])
  end
  
  def friend
    #@users_friend = User.find(Friend.find_by_request_to_id(current_user.id).request_from_id)	
	if params[:friend_id]
	  @user = User.find(params[:friend_id])
	  if !current_user.friend?(@user)
	    flash.now[:success] = "Request has sent to " + "#{@user.name}"
		current_user.friend!(@user)
	  else

      end

    end
    	@users_requested = current_user.requested_to_users
		@users_from = current_user.requested_from_users
	
	#current_user.friends.build(@user)
	#@users_friend = current_user.request_to_users
  end
end
