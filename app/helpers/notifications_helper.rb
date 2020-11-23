module NotificationsHelper

    # get all notifications for user (user id)
    def getUserNotifications(u)
        return User.find_by(id: u).notifications
    end
    
    # get invites/notifications for event (user id, event id)
    def getEventNotifications(u, e)
        @result = []
        @ns = Notification.all
        @ns.each do |n|
            if u == nil
                if (n.notification_type == 3 || n.notification_type == 4) && n.sender_id == e
                    @result.push(e)
                end
            else
                if (n.notification_type == 3 || n.notification_type == 4) && n.sender_id == e && n.user_id == u
                    @result.push(e)
                end
            end
        end
        return @result
    end

    # delete all user notifications (user id)
    def deleteUserNotifications(u)
        @ns = getUserNotifications(u)
        @ns.each do |n|
            n.destroy
        end
        redirect_to "/notifications", notice: "All notifications deleted."
    end

    # delete all notifications related to event (user id, event id)
    def deleteEventNotifications(u, e)
        @ns = getEventNotifications(u)
        @ns.each do |n|
            n.destroy
        end
        if u != nil
            redirect_to "/notifications", notice: "All notifications for " + Event.find_by(id: e).name + " deleted."
        end
    end

end
