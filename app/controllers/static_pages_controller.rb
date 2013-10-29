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
end
