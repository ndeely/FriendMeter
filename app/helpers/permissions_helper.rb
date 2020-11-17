module PermissionsHelper

  #check that user is logged in and an admin to continue
  def checkadmin
    if !user_signed_in?
      redirect_to root_path, :alert => 'You must be signed in and have administrator permissions to view this page.'
    elsif !current_user.admin?
      redirect_to root_path, :alert => 'You must be an administrator to view this page.'
    end
  end

  #check that user is signed in
  def signedin
    if current_user == nil
      redirect_to root_path, :alert => 'You must be logged in to view this page.'
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

  #appropriate permissions
  def permissions
    if isadmin
      return true
    end
    return false
  end

  # check two user ids are friends
  def areFriends (u1, u2)
    User.find_by(id: u1).friends.each do |friend|
      if friend.friend_id == u2
        return true
      end
    end
    return false
  end

  # check friend request status (current_user_id, other_user_id, sending [nil if false])
  # will return true if users are already friends
  def friendRequestSent(u1, u2, sending)
    @n = Notification.find_by(user_id: u2, sender_id: u1, notification_type: 1)
    if @n != nil || areFriends(u1, u2)
      return true
    end
    #request is sending
    if !@sent && sending != nil
      @sender = User.find_by(id: u1)
      @notification = User.find_by(id: u2).notifications.build(:user_id => u2, :title => 'Friend Request from ' + @sender.username.to_s, :desc => @sender.username.to_s + ' is awaiting your response.', :sender_id => u1, :notification_type => 1)
      @notification.save
      return true
    end
    return false
  end

  #check if user is invited to event (event_id, user_id)
  def isInvited(e1, u1)
    @n = Notification.find_by(notification_type: 3, sender_id: e1)
    if @n != nil
      return true
    end
    return false
  end

  #check if user is attending an event
  def isAttending(e1, u1)
    @a = Attending.find_by(event_id: e1, user_id: u1)
    if @a != nil
      return true
    end
    return false
  end

  #get name of u2 (current_user_id, user2_id)
  def getName(u1, u2)
    @name = ""
    if isadmin || (u1 == u2) || areFriends(u1, u2) #show real name
      @name = User.find_by(id: u2).fname.to_s + " " + User.find_by(id: u2).lname.to_s
    end
    @name = @name.eql?(" ") ? User.find_by(id: u2).username.to_s : @name
    return @name
  end

  #get profile picture of u2 (current_user_id, user2_id)
  def getPic(u1, u2)
    @pic = "ph.png"
    if @b1 || (u1 == u2) || areFriends(u1, u2) #show real pic
      @valid = User.find_by(id: u2).pic.split(".").last == "png" ||
               User.find_by(id: u2).pic.split(".").last == "jpg" ||
               User.find_by(id: u2).pic.split(".").last == "jpeg"
      if @valid
        @pic = User.find_by(id: u2).pic
      end
    end
    return @pic
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

  #delete notification if it exists (event id, user id)
  def deleteNotificationIfExists(e, u)
    @n = Notification.find_by(notification_type: 3, user_id: u, sender_id: e)
    if @n != nil
      @n.destroy
    end
  end

end