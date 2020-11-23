module StaticPagesHelper

    #get featured users
    def getFeaturedUsers
        @f = User.all
        return @f
    end

    #get featured events
    def getFeaturedEvents
        @f = Event.where(private: false)
        return @f
    end

    #get user-sm for user (user id)
    #used on homepage
    def getUserSm(u)
        @u = User.find_by(id: u)
        @html = '<div class="user-sm col-xs-6 col-md-4">' +
            '<a href="/users/' + u.to_s + '">' +
            '<p class="name">' + @u.username.to_s + '</p>' +
            '<p>'
        @html += @u.avatar.attached? ? '<image src="' + url_for(@u.avatar) + '">' : image_tag("ph.png")
        @html += '</p>' +
            '<p>Friends Made: ' + @u.friends.count.to_s + '</p>' +
            '<p>Events Created: ' + @u.events.count.to_s + '</p>' +
            '<p>Average User rating:<br>' + getAvgUserStarRating(u) + '</p>' +
            '</a>' +
            '</div>'
        return @html.html_safe
    end

    #get event-sm for event (event id)
    #used on homepage
    def getEventSm(e)
        @e = Event.find_by(id: e)
        @html = '<div class="event-sm col-xs-6 col-md-4">' +
            '<a href="/events/' + e.to_s + '">' +
            '<p class="name">' + @e.name.to_s + '</p>' +
            '<p>'
        @html += @e.avatar.attached? ? '<image src="' + url_for(@e.avatar) + '">' : image_tag("eph.png")
        @html += '</p>' +
            '<p>Attendees: ' + Attending.where(event_id: e).count.to_s + '</p>' +
            '<p>Created By: ' + User.find_by(id: @e.user_id).username + '</p>' +
            '</a>' +
            '</div>'
        return @html.html_safe
    end

    #get user-sm for friend (friend id)
    #used on friends main page
    def getFriendSm(f)
        @f = User.find_by(id: Friend.find_by(id: f).friend_id)
        @name = @f.fname.to_s + " " + @f.lname.to_s
        @name = @name.eql?(" ") ? @f.username.to_s : @name
        @html = '<div class="user-sm col-xs-4 col-md-2">' +
            '<a href="/users/' + @f.id.to_s + '">' +
            '<p class="name">' + @name + '</p>' +
            '<p>'
        @html += @f.avatar.attached? ? '<image src="' + url_for(@f.avatar) + '">' : image_tag("ph.png")
        if isadmin
            @f2 = User.find_by(id: Friend.find_by(id: f).user_id)
            @name = @f2.fname.to_s + " " + @f2.lname.to_s
            @name = @name.eql?(" ") ? @f2.username.to_s : @name
            @html += '</p>' +
                '<p>Friends with: ' + @name + '</p>'
        end
        @html += '</a>' +
            '</div>'
        return @html.html_safe
    end

end
