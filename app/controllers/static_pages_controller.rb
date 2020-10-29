class StaticPagesController < ApplicationController
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
    @b1 = false
    @user = User.find_by(id: params[:id])
    @allevents = Event.all
    @events = []
    @allevents.each do |event|
      if event.user_id == @user.id && !event.private
        @events.push(event)
      end
    end
    if isadmin# || current_user is friends with @user
      @b1 = true
    end


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
