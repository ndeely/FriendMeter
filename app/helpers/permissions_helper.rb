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
    if !user_signed_in?
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
    @user1 = User.find_by(id: u1)
    @friends = @user1.friends
    @friends.each do |friend|
      if friend.friend_id == u2
        return true
      end
    end
    return false
  end

  # check friend request status (current_user_id, other_user_id, sending [nil if false])
  def friendRequestSent(u1, u2, sending)
    @notifications = User.find_by(id: u2).notifications
    @notifications.each do |notification|
      if notification.type == 1 && notification.sender_id == u1
        @sent = true #request already sent
        return true
      end
    end
    #request is sending
    if !@sent && sending != nil
      @user = User.find_by(id: user_id)
      @other = User.find_by(id: other_id)
      @notification = @other.notifications.build(:user_id => @other.id, :title => 'Friend Request from ' + @user.username.to_s, :desc => @user.username.to_s + ' is awaiting your response.', :sender_id => @user.id, :type => 1)
      @notification.save
      return true
    end
    return false
  end

  #check if user is invited to event (event_id, user_id)
  def isInvited(e1, u1)
    @notifications = User.find_by(id: u1).notifications
    @notifications.each do |notification|
      if notification.type == 3 && notification.sender_id == e1
        @sent = true #invite already sent
        return true
      end
    end
    return false
  end

  #check if user is attending an event
  def isAttending(e1, u1)
    @attending = Event.find_by(id: e1).attending
    @attending.each do |attender|
      if attender.user_id == u1
        return true
      end
    end
    return false
  end

  #get name of u2 (current_user_id, user2_id)
  def getName(u1, u2)
    @name = @creator.username.to_s
    if @b1 || (u1 == u2) || areFriends(u1, u2) #show real name
      @name = User.find_by(id: u2).fname.to_s + " " + User.find_by(id: u2).lname.to_s
      @name = @name.eql?(" ") ? @creator.username.to_s : @name
    end
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

end