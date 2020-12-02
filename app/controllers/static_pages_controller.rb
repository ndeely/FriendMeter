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
    @html = getCoords(current_user.address)
  end

  def about
  end

  def getCoords(address)
    results = Geocoder.search("Diceys, Harcourt St, Dublin, Ireland")
    return results.first.coordinates
  end

    
end
