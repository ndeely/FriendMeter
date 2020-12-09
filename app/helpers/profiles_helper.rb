module ProfilesHelper
    #get large main profile for user (user id)
    def getProfileL(u)
        @cuid = isSignedIn ? current_user.id : nil
        @u = User.find_by(id: u)
        @b1 = isadmin
        @b2 = @b1 || @cuid == u
        @b3 = @b2 || areFriends(@cuid, u)
        @frs = friendRequestSent(@cuid, u)

        @html = '<h2>' + getName(@cuid, u) + '</h2>' +
            '<div class="profile-l">' +
            '<div class="col-xs-12 col-md-6">' +
            '<p class="image">'
        @html += getPic(@cuid, u)
        @html += '</p>' +
            '<a href="/user/' + u.to_s + '/reviews">' +
            '<p>User Rating: ' + getAvgUserStarRating(u) + '</p>' +
            '<p class="red">Reviews (' + getUserReviews(u).count.to_s + ')</p></a>' +
            '</div>' +
            '<div class="col-xs-12 col-md-6">' +
            '<p class="name">Bio</p>' +
            '<p>' + getBio(@cuid, u) + '</p><br>' +
            '<p>Friends Made: ' + @u.friends.count.to_s + '</p>' +
            '<p>Events Created: ' + @u.events.count.to_s + '</p>'
        if isSignedIn
            if !@b3 && !@frs
                @html += '<p><a class="btn btn-success" href="/users/' + u.to_s + '/' + @cuid.to_s + '">Send Friend Request</a></p>'
            elsif !@b3 && @frs
                @html += '<p class="green">Friend Request Sent</p>'
            elsif areFriends(@cuid, u)
                @html += '<p><a class="btn btn-danger" href="/users/' + u.to_s + '/' + @cuid.to_s + '/1">Unfriend</a></p>'
            end
        end
        @html += '</div>' +
            '<div class="clear"></div>' +
            '</div>'
        return @html.html_safe
    end
end

