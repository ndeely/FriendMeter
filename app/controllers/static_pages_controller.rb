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
    @b1 = isadmin
    @creator = User.find_by(id: params[:id])
    @b2 = @b1 || (current_user.id == @creator.id)
    @name = @creator.fname.to_s + " " + @creator.lname.to_s
    @name = (@name.eql?(" ") || !@b2) ? @creator.username.to_s : @name
    @allevents = @creator.events
    @events = []
    @allevents.each do |event|
      if !event.private || @b2
        @events.push(event)
      end
    end

    #handle friend requests
    @friend = false # already friends
    @friends = @creator.friends
    @friends.each do |friend|
      if friend.friend_id == current_user.id
        @friend = true
      end
    end

    @frs = false # friend request sent
    @notifications = @creator.notifications
    @notifications.each do |notification|
      if notification.sender_id == current_user.id
        @frs = true
      end
    end
    if !@frs && params[:id2] != nil
      @user = User.find_by(id: params[:id2])
      @notification = @creator.notifications.build(:user_id => @creator.id, :title => 'Friend Request from ' + @user.username.to_s, :desc => @user.username.to_s + ' is awaiting your response.', :sender_id => @user.id, :type => 1)
      @notification.save
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
