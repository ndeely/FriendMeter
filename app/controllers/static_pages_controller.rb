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
    @users = (params[:search] == nil ? User.all : searchUsers(params[:search]))
  end

    
end
