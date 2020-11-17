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

end
