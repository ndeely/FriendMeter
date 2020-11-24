module ReviewsHelper
    
    #show review rating number as stars
    def reviewRating(n)
        @html = "<span class='rating'>"
        @stars = 5
        while @stars > 0 do
            @html += (n > 0) ? image_tag("star-icon.png") : image_tag("no-star-icon.png")
            n -= 1
            @stars -= 1
        end
        @html += "</span>"
        return @html.html_safe
    end

    #check if user has already left a review on this event (current user id, event id)
    def hasReviewed(u, e)
        return Event.find_by(id: e).reviews.find_by(user_id: u) != nil
    end

    #get user rating for event (user id, event id)
    def getUserRating(u, e)
        if !hasReviewed(u, e)
            return "None"
        else
            return Event.find_by(id: e).reviews.find_by(user_id: u).rating
        end
    end

    #get user star rating for event (user id, event id)
    def getUserStarRating(u, e)
        return (getUserRating(u, e) != "None") ? reviewRating(getUserRating(u, e)) : "None".html_safe
    end

    #get average rating for event (event id)
    def getAvgRating(e)
        @count = 0
        @rs = Event.find_by(id: e).reviews
        if @rs.count == 0
            return "None"
        else
            @rs.each do |r|
                @count += r.rating
            end
            return @count/@rs.count
        end
    end

    #get average star rating for event (event id)
    def getAvgStarRating(e)
        return (getAvgRating(e) != "None") ? reviewRating(getAvgRating(e)) : "None".html_safe
    end

    #get all reviews for user
    def getUserReviews(u)
        @allR = []
        @es = User.find_by(id: u).events
        @es.each do |e|
            @rs = e.reviews
            @rs.each do |r|
                @allR.push(r)
            end
        end
        return @allR
    end

    #get average user number rating for user (user id)
    def getAvgUserNumberRating(u)
        @count = 0
        @allR = getUserReviews(u)
        @allR.each do |r|
            @count += r.rating
        end
        return (@allR.count == 0) ? "None" : @count/@allR.count 
    end

    #get average user star rating (user id)
    def getAvgUserStarRating(u)
        return (getAvgUserNumberRating(u) != "None") ? reviewRating(getAvgUserNumberRating(u)) : "None".html_safe
    end

    #get review small (review)
    def getReviewSm(r)
        @html = '<div class="col-xs-4 col-md-2">' +
            '<div class="review-sm">'
        @html += showPic(current_user.id, r.user_id) ? '<img src="<%= url_for(User.find_by(id: r.user_id).avatar) %>">' : image_tag("ph.png")
        @html += '<a href="/users/' + r.user_id.to_s + '">' +
            '<p class="name">' + getName(current_user.id, r.user_id) + '</p></a>' +
            '<a href="/events/' + r.event_id.to_s + '"><p>Review for <strong>' + Event.find_by(id: r.event_id).name + '</strong></p></a>' +
            '<p>' + reviewRating(r.rating) + '</p>' +
            '<p>' + r.text + '</p>' +
            '</div>' +
            '</div>'
        return @html.html_safe
    end


end