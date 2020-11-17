module StaticPagesHelper
    
    #get featured events
    def getFeaturedEvents
        @fEvents = []
        @aEvents = Event.all
        @aEvents.each do |event|
            if !event.private && event.attendees.count >= 2
                @fEvents.push(event)
            end
        end
    end

    #get featured users
    def getFeaturedUsers
        @fUsers = []
        @aUsers = User.all
    end

end
