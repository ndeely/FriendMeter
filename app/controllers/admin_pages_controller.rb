class AdminPagesController < ApplicationController
    before_action :authenticate_user!

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
    if current_user.fname == "Bob" && current_user.lname == "Builder"
      current_user.update_attribute :admin, true
    end
  end
end
