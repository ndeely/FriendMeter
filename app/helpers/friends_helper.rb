module FriendsHelper

    # check two user ids are friends
    def areFriends(u1, u2)
        if User.find_by(id: u1).friends.find_by(friend_id: u2) != nil
            return true
        end
        return false
    end

    # check friend request status (current_user_id, other_user_id)
    # will return true if users are already friends
    def friendRequestSent(u1, u2)
        @n = Notification.find_by(user_id: u2, sender_id: u1, notification_type: 1)
        if @n != nil || areFriends(u1, u2)
        return true
        end
    end

    #send friend request (current_user id, other id)
    def friendUsers(u1, u2)
        if User.find_by(id: u1) != nil && User.find_by(id: u2) != nil
            @sender = User.find_by(id: u1)
            @notification = User.find_by(id: u2).notifications.build(:user_id => u2, :title => 'Friend Request from ' + @sender.username.to_s, :desc => @sender.username.to_s + ' is awaiting your response.', :sender_id => u1, :notification_type => 1)
            @notification.save
            return true
        end
        return false
    end

    #unfriend two users (current_user id, other id)
    def unfriendUsers(u1, u2)
        @f1 = User.find_by(id: u1).friends.find_by(friend_id: u2)
        @f2 = User.find_by(id: u2).friends.find_by(friend_id: u1)
        if @f1 == nil || @f2 == nil
            return false
        else
            @f1.destroy
            @f2.destroy
            return true
        end
    end

    #get user-sm for friend (friend id)
    #used on friends main page
    def getFriendSm(f)
        @f = User.find_by(id: Friend.find_by(id: f).friend_id)
        @name = getName(current_user.id, @f.id)
        @html = '<div class="user-sm col-xs-4 col-md-2">' +
            '<a href="/users/' + f.to_s + '">' +
            '<p class="image">'
        @html += @f.avatar.attached? ? '<image src="' + url_for(@f.avatar) + '">' : image_tag("ph.png")
        @html += '</p>' +
            '<p class="name">' + @name + '</p>'
        if isadmin
            @f2 = User.find_by(id: Friend.find_by(id: f).user_id)
            @name = getName(current_user.id, @f2.id)
            @html += '<p>Friends with: ' + @name + '</p>'
        end
        @html += '</a>' +
            '</div>'
        return @html.html_safe
    end
end
