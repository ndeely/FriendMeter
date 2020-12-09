module EventsHelper

    #check if user u is invited to event e (event_id, user_id)
    def isInvited(e, u)
        if u != nil
            @n = User.find_by(id: u).notifications.find_by(notification_type: 3, sender_id: e)
            if @n != nil
                return true
            end
        end
        return false
    end

    #check if user u is attending an event e
    def isAttending(e, u)
        if u != nil
            @a = Attending.find_by(event_id: e, user_id: u)
            if @a != nil
                return true
            end
        end
        return false
    end

    #send u an invite to event e owned by current user (event id, user id)
    def sendEventInvite(e, u)
        if !isSignedIn
            redirect_to root_url, notice: "You must be signed in to send invites."
        else
            @e = current_user.events.find_by(id: e)
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
                @n = @u.notifications.build(:user_id => u, :title => 'New Event Invite', :desc => getName(u, current_user.id) + " has invited you to attend their event " + @e.name + ".", :sender_id => e, :notification_type => 3)
                @n.save
                respond_to do |format|
                    format.html { redirect_to '/users/' + u, notice: 'Invitation Sent.' }
                    format.json { head :no_content }
                end
            end
        end
    end

    #user u is accepting an invited to event e (event id, user id)
    def acceptEventInvite(e, u)
        if e == nil
            redirect_to '/events/', notice: "This event does not exist."
        elsif u == nil
            redirect_to root_url, notice: "This user does not exist."
        else
            @e = Event.find_by(id: e)
            @u = User.find_by(id: u)

            if @e == nil
                redirect_to '/events/', notice: "This event does not exist."
            elsif @u == nil
                redirect_to root_url, notice: "This user does not exist."
            elsif isAttending(e, u)
                redirect_to '/events/' + e.to_s, notice: "You are already attending this event."
            elsif !isInvited(e, u)
                redirect_to '/events/', notice: "You have not been invited to this event."
            else
                @a = @e.attending.build(event_id => e, user_id => u)
                @a.save
                # delete notification after
                @n = @u.notifications.find_by(user_id: u, sender_id: e, notification_type: 3)
                @n.destroy
                respond_to do |format|
                    format.html { redirect_to '/events/' + e.to_s, notice: 'Invitation Accepted.' }
                    format.json { head :no_content }
                end
            end
        end
    end

    #get color of name in chat messages (comment.user_id, @event.user_id)
    def getChatColor(uid, euid)
        if (isSignedIn ? current_user.id : nil) == uid
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

    #get user's events that haven't ended (user id)
    def getUnfinishedEvents(u)
        @es = []
        if u != nil
            @alles = User.find_by(id: u).events
            @alles.each do |e|
                if !eventEnded(e)
                    @es.push(e)
                end
            end
        end
        return @es
    end

    #get user's events that have ended (user id, boolean includePrivate)
    def getFinishedEvents(u, b)
        @es = []
        if u != nil
            @alles = User.find_by(id: u).events
            @alles.each do |e|
                if eventEnded(e) && (b ? e.private : true)
                    @es.push(e)
                end
            end
        end
        return @es
    end

    #delete all x (array x)
    #used by events#destroy for deleting info for event being deleted
    def deleteAll(xs)
        xs.each do |x|
            x.destroy
        end
    end

    #get event-sm for event (event id)
    #used on homepage
    def getEventSm(e)
        @e = Event.find_by(id: e)
        @html = '<div class="col-xs-6 col-md-4">' +
            '<div class="event-sm">' +
            '<a href="/events/' + e.to_s + '">' +
            '<p class="image">'
        @html += @e.avatar.attached? ? '<image src="' + url_for(@e.avatar) + '">' : image_tag("eph.png")
        @html += '</p>' +
            '<p class="name">' + @e.name.to_s + '</p>' +
            '<p>' + @e.date.to_s + " " + @e.time.strftime("%I:%M %p").to_s + '</p>' +
            '<p>' + @e.address.to_s + '</p>' +
            #(isSignedIn ? ((coordsSet(current_user.id, "u") && coordsSet(e, "e")) ? '<p>Distance: ' + userDist(current_user.id, e).round(3).to_s + ' km</p>'.html_safe : "") : "") +
            '<p>Attendees: ' + Attending.where(event_id: e).count.to_s + '</p>' +
            '</a>' +
            '<p>Organised By: ' + (link_to getName(isSignedIn ? current_user.id : nil, @e.user_id), '/users/' + @e.user_id.to_s) + '</p>'
        if eventEnded(e) #show reviews
            @html += '<a href="/events/' + e.to_s + '#reviews">' +
                '<p>' + getAvgStarRating(e) + '</p>' +
                '<p class="red">Reviews (' + @e.reviews.count.to_s + ')</p></a>'
        else #show comments
            @html += '<a href="/events/' + e.to_s + '#comments">' +
                '<p class="red">Comments (' + @e.comments.count.to_s + ')</p></a>'
        end
        @html += '</div>' +
            '</div>'
        return @html.html_safe
    end

    #get medium sized event (event id, user id who's profile current user is on)
    def getEventMd(e, u)
        @cuid = isSignedIn ? current_user.id : nil
        @e = Event.find_by(id: e)
        @html = '<a href="/events/' + @e.id.to_s + '">' +
            '<div class="col-xs-12 col-md-6">' +
            '<div class="event-md">' +
            '<p class="image">'
        @html += @e.avatar.attached? ? '<image src="' + url_for(@e.avatar) + '">' : image_tag("eph.png")
        @html += '</p>' +
            '<p class="name">' + @e.name + '</p>' +
            '<p>' + @e.description + '</p>' +
            '<p>' + @e.date.to_s + " " + @e.time.strftime("%I:%M %p") + '</p>' +
            '<p>' + @e.address.to_s + '</p>' +
            #((coordsSet(@cuid, "u") && coordsSet(e, "e")) ? '<p>Distance: ' + userDist(@cuid, e).round(3).to_s + ' km</p>'.html_safe : "") +
            '<p>Attendees: ' + Attending.where(event_id: e).count.to_s + '</p>'
        @html += (@cuid == @e.user_id) ? "<p>Public: " + (!@e.private ? image_tag("tick.png") : image_tag("red-x.png")) + "</p>" : ""
        @html += '</a>'
        # show invited/attending status if on user's profile
        if @e.user_id == @cuid && !eventEnded(e) && u != nil #this is current user's event
            if isInvited(e, u)
                @html += '<p class="green">Invited</p>'
            elsif isAttending(e, u)
                @html += '<p class="green">Attending</p>'
            else
                @html += '<a class="btn btn-success" href="/events/' + @e.id.to_s + '/' + u.to_s + '/1">Invite User</a>'
            end
        elsif (@e.user_id == u || u == nil) && !eventEnded(e) #this is other user's event
            if isAttending(e, @cuid)
                @html += '<p class="green">You are attending this event.</p>' +
                '<p><a class="btn btn-danger" href="/events/' + @e.id.to_s + '/2">Unattend Event</a></p>'
            elsif isInvited(e, @cuid)
                @html += '<p class="green">You are invited to this event.</p>' +
                    '<p><a class="btn btn-success" href="/events/' + @e.id.to_s + '/' + @e.user_id.to_s + '/2">Accept Invitation</a></p>'
            else
                @html += '<p class="red">You are not attending this event.</p>' +
                    '<p><a class="btn btn-success" href="/events/' + @e.id.to_s + '/1">Attend Event</a></p>'
            end
        elsif eventEnded(e)
            if isAttending(e, @cuid)
                if !(hasReviewed(@cuid, e))
                    @html += '<p><a class="btn btn-success" href="/events/' + e.to_s + '#reviews">Review</a></p>'
                else
                    @html += '<p>Your Review: ' + getUserStarRating(@cuid, e) + '</p>'
                end
            end
            @html += '<p>Average Review: ' + getAvgStarRating(e) + '</p>'
        end
        @html += '<p>Organised By: ' + (link_to getName(@cuid, @e.user_id), '/users/' + @e.user_id.to_s) + '</p>' +
            '</div>' +
            '</div>'
        return @html.html_safe
    end

    #get large main event (event id)
    def getEventL(e)
        @cuid = isSignedIn ? current_user.id : nil
        @e = Event.find_by(id: e)
        @b1 = isadmin
        @b2 = @b1 || (@cuid == @e.user_id)
        
        @html = eventEnded(e) ? '<p class="summary">This event has ended.<br>Average Rating: ' + getAvgStarRating(e) + '</p>' : ""
        @html += '<h2>' + @e.name + '</h2>' +
            '<div class="event-l">' +
            '<div class="col-xs-12 col-md-4">' +
            '<p class="image">'
        @html += @e.avatar.attached? ? '<image src="' + url_for(@e.avatar).to_s + '">' : image_tag("eph.png")
        @html += '</p>' +
            '</div>' +
            '<div class="col-xs-12 col-md-4">' +
            '<p class="name">' + @e.description + '</p>' +
            '<p>' + @e.date.to_s + ' ' + @e.time.strftime("%I:%M %p").to_s + '</p>' +
            '<p>' + @e.address.to_s + '</p>' +
            #((coordsSet(@cuid, "u") && coordsSet(e, "e")) ? '<p>Distance: ' + userDist(@cuid, e).round(3).to_s + ' km</p>'.html_safe : "") +
            (isadmin ? '<p>{' + @e.lat.to_s + ", " + @e.lng.to_s + '}</p>' : "") +
            '<p>Public: ' + (!@e.private ? "Yes" : "No") + '</p>' +
            '<p>Organised By: ' + (link_to getName(@cuid, @e.user_id), '/users/' + @e.user_id.to_s) + '</p>' +
            '<p>'
        if @b1 || (@b2 && !eventEnded(e)) #show event buttons
            @html += '<a class="btn btn-warning" href="' + edit_event_path(@e) + '">Edit</a>' +
                (link_to 'Delete', @e, method: :delete, :role=>"button", :class => "btn btn-danger", data: { confirm: 'Are you sure?' })
        end
        @html += '<a class="btn btn-info" href="javascript: history.go(-1)">Back</a>' +
            '</p>' +
            '</div>' +
            '<div class="col-xs-12 col-md-4">' +
            '<div id="map-container">' +
            '<div id="map"></div>' +
            '</div>' +
            (javascript_pack_tag 'mapPoint') +
            '</div>' +
            '<div class="clear"></div>' +
            '</div>'
        return @html.html_safe
    end

    #search events for word
    def searchEvents(word)
        @w = word.downcase()
        @ufEvents = Event.all
        @es = []
        @ufEvents.each do |e|
            if e.name.to_s.downcase().include?(@w) ||
                e.description.to_s.downcase().include?(@w) ||
                e.street.to_s.downcase().include?(@w) ||
                e.city.to_s.downcase().include?(@w) ||
                e.state.to_s.downcase().include?(@w) ||
                e.country.to_s.downcase().include?(@w) ||
                User.find_by(id: e.user_id).username.downcase().include?(@w)
                @es.push(e)
            end
        end
        return @es
    end

    #get distance between two points of lat, lng in km (lat1, lng1, lat2, lng2)
    #TODO (get working)
    def distanceBetween(lat1, lng1, lat2, lng2)
        @R = 6371
        @c1 = lat1 * Math::PI/180 #0.927
        @c2 = lat2 * Math::PI/180 #0.931
        @dLat = (lat2 - lat1) * Math::PI/180 #0.004
        @dLng = (lng2 - lng1) * Math::PI/180 #-0.004
        
        @a = Math.sin(@dLat/2) * Math.sin(@dLng/2) +
            Math.cos(@c1) * Math.cos(@c2) *
            Math.sin(@dLng/2) * Math.sin(@dLng/2) #0.999737
        
        @c = 2 * Math.atan2(Math.sqrt(@a), Math.sqrt(1 - @a))

        return @R * @c
    end

    # distance from user to event (user id, event id)
    #TODO
    def userDist(u, e)
        @u = User.find_by(id: u)
        @e = Event.find_by(id: e)
        return distanceBetween(@u.lat, @u.lng, @e.lat, @e.lng)
    end

    #get nearby events
    def nearbyEvents
        @es = []
        @ufEvents = Event.all
        @ufEvents.each do |e|
            #if coordsSet(current_user.id, "u") && coordsSet(e.id, "e")
            #    if userDist(current_user.id, e) <= 50
            #        @es.push(e)
            #    end
            if addrSet(current_user.id, "u") && addrSet(e.id, "e")
                if User.find_by(id: current_user.id).country == Event.find_by(id: e.id).country &&
                    User.find_by(id: current_user.id).state == Event.find_by(id: e.id).state
                    @es.push(e)
                end
            end
        end
        return @es
    end

end
