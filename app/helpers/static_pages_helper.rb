module StaticPagesHelper

    #get featured users
    def getFeaturedUsers
        @f = User.all.limit(6)
        return @f
    end

    #get featured events
    def getFeaturedEvents
        @f = Event.where(private: false).where("date > ?", Date.today).order(:date).limit(3)
        return @f
    end

    #get featured events
    def getFeaturedPastEvents
        @f = Event.where(private: false).where("date < ?", Date.today).order(date: :desc).limit(3)
        return @f
    end

    #get recent reviews
    def getRecentReviews
        @rs = Review.all.order(:created_at).limit(5)
        return @rs
    end

    #get user-sm for user (user id)
    #used on homepage
    def getUserSm(u)
        @u = User.find_by(id: u)
        @html = '<div class="col-xs-6 col-md-4">' +
            '<div class="user-sm">' +
            '<a href="/users/' + u.to_s + '">' +
            '<p class="image">'
        @html += getPic(isSignedIn ? current_user.id : nil, u)
        @html += '</p>' +
            '<p class="name">' + getName(isSignedIn ? current_user.id : nil, u) + '</p>' +
            '<p>Friends Made: ' + @u.friends.count.to_s + '</p>' +
            '<p>Events Created: ' + @u.events.count.to_s + '</p>' +
            '</a>' +
            '<a href="/user/' + @u.id.to_s + '/reviews">' +
            '<p>' + getAvgUserStarRating(@u) + '</p>' +
            '<p class="red">Reviews (' + getUserReviews(@u).count.to_s + ')</p></a>' +
            '</div>' +
            '</div>'
        return @html.html_safe
    end

end
