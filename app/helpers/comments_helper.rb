module CommentsHelper

    #get comment small (comment)
    #used on comment notifications
    def getCommentSm(c)
        @cuid = isSignedIn ? current_user.id : nil
        @html = '<div class="comment-sm">' +
            '<div class="col-xs-4">'
        @html += showPic(@cuid, c.user_id) ? '<img src="' + url_for(User.find_by(id: c.user_id).avatar) + '">' : image_tag("ph.png").to_s
        @html += '</div>' +
            '<div class="col-xs-8">' +
            '<p>' + c.text + '</p>' +
            '</div>' +
            '</div>' + 
            '<div class="clear"></div>'
        return @html.html_safe
    end

end
