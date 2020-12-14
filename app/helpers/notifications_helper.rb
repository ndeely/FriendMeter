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
                if (n.notification_type == 3 || n.notification_type == 4) && n.sender_id == e.to_i
                    @result.push(n)
                end
            else
                if (n.notification_type == 3 || n.notification_type == 4) && n.sender_id == e.to_i && n.user_id == u.to_i
                    @result.push(n)
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

    # delete all notifications related to event for user (user id, event id)
    def deleteEventNotifications(u, e)
        @ns = getEventNotifications(u, e)
        @ns.each do |n|
            n.destroy
        end
        if u != nil
            redirect_to "/notifications", notice: "All notifications for " + Event.find_by(id: e).name + " deleted."
        end
    end

    #get notification small (notification id)
    def getNotificationSm(n)
        @ntype = n.notification_type
        @html = '<div class="col-xs-12 col-md-4">' +
            '<div class="notification-sm">' +
            '<p class="name">' + n.title + '</p>' +
            '<p>' + n.desc + '</p>' +
            '<p class="buttons">'
        @html += (@ntype == 1 || @ntype == 2) ? '<a class="btn btn-info" href="/users/' + n.sender_id.to_s + '">User</a>' : ""
        @html += (@ntype == 3 || @ntype == 4) ? '<a class="btn btn-info" href="/events/' + n.sender_id.to_s + '">Event</a>' : ""
        @html += (@ntype == 1 || @ntype == 3) ? '<a class="btn btn-success" href="/notifications/' + n.id.to_s + '/' + @ntype.to_s + '">Accept</a>' : ""
        @html += link_to 'Delete', n, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-danger"
        @html += (@ntype == 3 || @ntype == 4) ? (link_to 'Delete all notifications for this event', '/notifications/' + n.sender_id.to_s + "/8", data: { confirm: 'Are you sure?' }, class: "btn btn-danger") : ""
        @html += '</p>' +
            '</div>' +
            '</div>'
        return @html.html_safe
    end

end
