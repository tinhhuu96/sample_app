class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost  = current_user.microposts.build
    @feed_items = Micropost.find_post_by_id(current_user.id).paginate(page: params[:page])
  end
end
