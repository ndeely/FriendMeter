module ProfilesHelper
    #get large main profile for user (user id)
    def getProfileL(u)
        @u = User.find_by(id: u)
        @b1 = isadmin
        @b2 = @b1 || current_user.id == u
        @b3 = @b2 || areFriends(current_user.id, u)
        @frs = friendRequestSent(current_user.id, u)

        @html = '<h2>' + getName(current_user.id, u) + '</h2>' +
            '<div class="profile-l">' +
            '<div class="col-xs-12 col-md-6">' +
            '<p class="image">'
        @html += showPic(current_user.id, u) ? '<image src="' + url_for(@u.avatar).to_s + '">' : image_tag("ph.png")
        @html += '</p>' +
            '<a href="/user/' + u.to_s + '/reviews">' +
            '<p>User Rating: ' + getAvgUserStarRating(u) + '</p>' +
            '<p class="red">Reviews (' + getUserReviews(u).count.to_s + ')</p></a>' +
            '</div>' +
            '<div class="col-xs-12 col-md-6">' +
            '<p class="name">Bio</p>' +
            '<p>' + getBio(current_user.id, u) + '</p><br>' +
            '<p>Friends Made: ' + @u.friends.count.to_s + '</p>' +
            '<p>Events Created: ' + @u.events.count.to_s + '</p>'
        if !@b3 && !@frs
            @html += '<p><a class="btn btn-success" href="/users/' + u.to_s + '/' + current_user.id.to_s + '">Send Friend Request</a></p>'
        elsif !@b3 && @frs
            @html += '<p class="green">Friend Request Sent</p>'
        elsif areFriends(current_user.id, u)
            @html += '<p><a class="btn btn-danger" href="/users/' + u.to_s + '/' + current_user.id.to_s + '/1">Unfriend</a></p>'
        end
        @html += '</div>' +
            '<div class="clear"></div>' +
            '</div>'
        return @html.html_safe
    end
end

