class AdminPagesController < ApplicationController
  before_action :authenticate_user!
  include PermissionsHelper

  def allusers
    checkadmin
    @users = User.all
  end

  def admin
    checkadmin
  end

  #add/remove admin status
  def upgrade
    checkadmin
    @user = User.find_by(id: params[:id])
    if @user.update_attribute(:admin, true)
      redirect_to "/users", :notice => 'User upgraded'
    else
      redirect_to "/users", :alert => 'Something went wrong'
    end
  end
  
  def downgrade
    checkadmin
    @user = User.find_by(id: params[:id])
    if @user.update_attribute(:admin, false)
      redirect_to "/users", :notice => 'User downgraded'
    else
      redirect_to "/users", :alert => 'Something went wrong'
    end
  end

  #add/remove premium user status
  def prem
    checkadmin
    @user = User.find_by(id: params[:id])
    if @user.update_attribute(:premium, true)
      redirect_to "/users", :notice => 'User given premium status'
    else
      redirect_to "/users", :alert => 'Something went wrong'
    end
  end
  
  def notprem
    checkadmin
    @user = User.find_by(id: params[:id])
    if @user.update_attribute(:premium, false)
      redirect_to "/users", :notice => 'User premium status removed'
    else
      redirect_to "/users", :alert => 'Something went wrong'
    end
  end

  def make_admin
    if current_user.username == "AdminBob" && current_user.email == "bob@the.builder"
      if current_user.update_attribute(:admin, true)
        redirect_to "/", :notice => 'You are now an admin'
      else
        redirect_to "/", :notice => 'You do not have the correct permissions for this page'
      end
    else
      redirect_to "/", :notice => 'You do not have the correct permissions for this page'
    end
  end
end
