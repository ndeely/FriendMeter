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

  #does u1 have permission to see name of u2 (user1_id, user2_id)
  #and is there one available
  def getName(u1, u2)
    @u = User.find_by(id: u2)
    if u1 == nil || @u.fname == nil || @u.lname == nil
      return @u.username.to_s
    else
      @name = " "
      if isadmin || (u1 == u2) || areFriends(u1, u2) #show real name
        @name = @u.fname.to_s + " " + @u.lname.to_s
      end
      @name = @name.eql?(" ") ? @u.username.to_s : @name
      return @name
    end
  end

  #does u1 have permission to see profile picture of u2 (user1_id, user2_id)
  #and is there one available
  def showPic(u1, u2)
    if isadmin || (u1 == u2) || areFriends(u1, u2) #show real pic
      if User.find_by(id: u2).avatar.attached?
        return true
      end
    end
    return false
  end

  #get u2's profile pic for u1 (user1_id, user2_id)
  #if there is one available
  def getPic(u1, u2)
    if showPic(u1, u2)
      return ('<img src="' + url_for(User.find_by(id: u2).avatar) + '">').html_safe
    else
      return image_tag("ph.png")
    end
  end

  #get bio of u2 for u1 if there is one available (user1_id, user2_id)
  def getBio(u1, u2)
    if isadmin || (u1 == u2) || areFriends(u1, u2)
      if User.find_by(id: u2).bio == nil
        return "This user has not created a bio yet."
      elsif isadmin || (u1 == u2) || areFriends(u1, u2)
        return User.find_by(id: u2).bio
      end
    else
      return "Add this user as a friend to see their bio."
    end
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