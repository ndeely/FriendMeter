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
    if isadmin# || current_user is friends with @user
      @b1 = true
    end


  end

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

  def checkadmin
    if !user_signed_in?
      redirect_to root_path, :alert => 'You must be signed in and have administrator permissions to view this page.'
    elsif !current_user.admin?
      redirect_to root_path, :alert => 'You must be an administrator to view this page.'
    end
  end

  def isadmin
    if user_signed_in?
      if current_user.admin?
        return true
      end
    end
    return false
  end
    
end
