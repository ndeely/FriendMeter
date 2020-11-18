module PermissionsHelper

  #check that user is logged in and an admin to continue
  def checkadmin
    if !user_signed_in?
      redirect_to root_path, :alert => 'You must be signed in and have administrator permissions to view this page.'
    elsif !current_user.admin?
      redirect_to root_path, :alert => 'You must be an administrator to view this page.'
    end
  end

  #redirect if user is not signed in
  def signedin
    if current_user == nil
      redirect_to root_path, :alert => 'You must be logged in to view this page.'
    end
  end

  #check if user is signed in
  def isSignedIn
    return current_user != nil
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

  #appropriate permissions
  def permissions
    if isadmin
      return true
    end
    return false
  end

  #get name of u2 (current_user_id, user2_id)
  def getName(u1, u2)
    if u1 == nil
      return User.find_by(id: u2).username.to_s
    else
      @name = " "
      if isadmin || (u1 == u2) || areFriends(u1, u2) #show real name
        @name = User.find_by(id: u2).fname.to_s + " " + User.find_by(id: u2).lname.to_s
      end
      @name = @name.eql?(" ") ? User.find_by(id: u2).username.to_s : @name
      return @name
    end
  end

  #does u1 have permission to see profile picture of u2 (current_user_id, user2_id)
  #and is there one available
  def showPic(u1, u2)
    if @b1 || (u1 == u2) || areFriends(u1, u2) #show real pic
      if User.find_by(id: u2).avatar.attached?
        return true
      end
    end
    return false
  end

  #set avatar (picture) for user/event (user/event, avatar)
  def setAvatar(ue, a)
    if a != nil
      if ue.avatar.attached?
        ue.avatar.purge
      end
      ue.avatar.attach(a)
    end
  end

  #delete event e invite notification for user u if it exists (event id, user id)
  def deleteNotificationIfExists(e, u)
    @n = Notification.find_by(notification_type: 3, user_id: u, sender_id: e)
    if @n != nil
      @n.destroy
    end
  end

end