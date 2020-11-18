module ReviewsHelper
    
    #show review rating number as stars
    def reviewRating(n)
        @html = ""
        @stars = 5
        while @stars > 0 do
            @html += (n > 0) ? image_tag("star-icon.png") : image_tag("no-star-icon.png")
            n -= 1
            @stars -= 1
        end
        return @html
    end

end
