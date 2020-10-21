class StaticPagesController < ApplicationController
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

  #check that user is logged in and an admin to continue
  def checkadmin
    if !user_signed_in?
      redirect_to root_path, :alert => 'You must be signed in and have administrator permissions to view this page.'
    elsif !current_user.admin?
      redirect_to root_path, :alert => 'You must be an administrator to view this page.'
    end
  end

  #return true if user is signed in and an admin
  def isadmin
    if user_signed_in?
      if current_user.admin?
        return true
      end
    end
    return false
  end
    
end
