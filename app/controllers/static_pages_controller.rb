class StaticPagesController < ApplicationController
  include PermissionsHelper
  include StaticPagesHelper
  include ReviewsHelper
  include FriendsHelper
  include EventsHelper

  def home
    @fUsers = getFeaturedUsers
    @fEvents = getFeaturedEvents
    @fpEvents = getFeaturedPastEvents
    @rs = getRecentReviews
  end

  def users
    if params[:search] == ""
      redirect_to "/users", notice: "This is not a valid search."
    end
    @users = (params[:search] == nil ? User.all : searchUsers(params[:search]))
  end

  def about

  end

    
end
