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

  def help
  end

  def about
  end
    
end
