class StaticPagesController < ApplicationController
  include PermissionsHelper
  include StaticPagesHelper

  def home
    @fUsers = getFeaturedUsers
    @fEvents = getFeaturedEvents
  end

  def help
  end

  def about
  end
    
end
