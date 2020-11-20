module EventsHelper

    #check if user u is invited to event e (event_id, user_id)
    def isInvited(e, u)
        @n = User.find_by(id: u).notifications.find_by(notification_type: 3, sender_id: e)
        if @n != nil
        return true
        end
        return false
    end

    #check if user u is attending an event e
    def isAttending(e, u)
        @a = Attending.find_by(event_id: e, user_id: u)
        if @a != nil
        return true
        end
        return false
    end

    #send u an invite to event e owned by cu (event id, user id, current user id)
    def sendEventInvite(e, u, cu)
        @e = User.find_by(id: cu).events.find_by(id: e)
        @u = User.find_by(id: u)

        if @e == nil
            redirect_to '/users/' + u, notice: "You do not own this event."
        elsif @u == nil
            redirect_to root_url, notice: "This user does not exist."
        elsif isAttending(e, u)
            redirect_to '/users/' + u, notice: "This user is already attending this event."
        elsif isInvited(e, u)
            redirect_to '/users/' + u, notice: "This user is already invited to this event."
        else
            @n = @u.notifications.build(:user_id => u, :title => 'You have been invited to an event!', :desc => 'The sender is awaiting your response.', :sender_id => e, :notification_type => 3)
            @n.save
            respond_to do |format|
                format.html { redirect_to '/users/' + u, notice: 'Invitation Sent.' }
                format.json { head :no_content }
            end
        end
    end

    #get color of name in chat messages (current_user.id, comment.user_id, @event.user_id)
    def getChatColor(cuid, uid, euid)
        if cuid == uid
            return "you"
        elsif uid == euid
            return "creator"
        else
            return "other"
        end
    end

    #find out if event e has ended (event id)
    def eventEnded(e)
        return Date.today > Event.find_by(id: e).date
    end

end
