class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  include PermissionsHelper

  def home
  end

  def help
  end

  def about
  end

  def allusers
    checkadmin
    @users = User.all
  end
  
  def admin
    checkadmin
  end

  def profile
    @b1 = isadmin
    @creator = User.find_by(id: params[:id])

    #handle friend requests
    @friend = areFriends(@creator.id, current_user.id)

    @b2 = @b1 || (current_user.id == @creator.id)
    @b3 = @b2 || @friend
    @name = getName(current_user.id, @creator.id)
    #@pic = getPic(current_user.id, @creator.id)
    @allevents = @creator.events
    @events = []
    @allevents.each do |event|
      #check if user is invited
      @invited = isInvited(event.id, current_user.id)

      if !event.private || @b2 || @invited
        @events.push(event)
      end
    end

    #check friend request status
    @frs = friendRequestSent(current_user.id, @creator.id, params[:id2])
  end

  #add/remove admin status
  def upgrade 
    @user = User.find_by(id: params[:id])
    if @user.update_attribute(:admin, true)
      redirect_to "/users", :notice => 'User upgraded'
    else
      redirect_to "/users", :alert => 'Something went wrong'
    end
  end
  
  def downgrade 
    @user = User.find_by(id: params[:id])
    if @user.update_attribute(:admin, false)
      redirect_to "/users", :notice => 'User downgraded'
    else
      redirect_to "/users", :alert => 'Something went wrong'
    end
  end

  #add/remove premium user status
  def prem 
    @user = User.find_by(id: params[:id])
    if @user.update_attribute(:premium, true)
      redirect_to "/users", :notice => 'User given premium status'
    else
      redirect_to "/users", :alert => 'Something went wrong'
    end
  end
  
  def notprem
    @user = User.find_by(id: params[:id])
    if @user.update_attribute(:premium, false)
      redirect_to "/users", :notice => 'User premium status removed'
    else
      redirect_to "/users", :alert => 'Something went wrong'
    end
  end
    
end
