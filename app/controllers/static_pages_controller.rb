class StaticPagesController < ApplicationController
  include PermissionsHelper
  include StaticPagesHelper
  include ReviewsHelper

  def home
    @fUsers = getFeaturedUsers
    @fEvents = getFeaturedEvents
  end

  def help
  end

  def about
  end
    
end
