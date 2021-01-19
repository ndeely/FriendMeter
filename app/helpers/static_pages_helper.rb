module StaticPagesHelper

    #get featured users
    def getFeaturedUsers
        @us = User.all
        @f = []
        @us.each do |u|
            if u.admin != true
                @f.push(u)
            end
        end
        @f = @f.sort_by{ |u| [u.events.count, u.friends.count] }.reverse.take(6)
        return @f
    end

    #get featured events
    def getFeaturedEvents
        @es = Event.where(private: false).where("date > ?", Date.today).order(:date)
        @f = @es.sort_by{ |e| [e.attendings.count, e.comments.count] }.reverse.take(3)
        return @f
    end

    #get featured past events
    def getFeaturedPastEvents
        @es = Event.where(private: false).where("date < ?", Date.today).order(date: :desc)
        @f = @es.sort_by{ |e| [e.attendings.count, e.comments.count] }.reverse.take(3)
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

    #search friends for word
    def searchUsers(word)
        @cuid = isSignedIn ? current_user.id : nil
        @w = word.downcase()
        @usUnf = User.all # users unfiltered
        @us = []
        @usUnf.each do |u|
            @friendOrAdmin = areFriends(@cuid, u.id) || ((@cuid != nil) ? (User.find_by(id: @cuid).admin == true) : false)
            if u.username.downcase().include?(@w) || 
                (@friendOrAdmin ? 
                    ((u.fname != nil) ? u.fname.downcase().include?(@w) : false) || 
                    ((u.lname != nil) ? u.lname.downcase().include?(@w) : false)
                : false)
                @us.push(u)
            end
        end
        return @us
    end

end
