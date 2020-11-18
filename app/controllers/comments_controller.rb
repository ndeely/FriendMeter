class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  include PermissionsHelper
  include EventsHelper

  # GET /comments
  # GET /comments.json
  def index
    isadmin
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    isadmin
  end

  # GET /comments/new
  def new
    isadmin
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    isadmin
  end

  # POST /comments
  # POST /comments.json
  def create
    @event = Event.find_by(id: comment_params[:event_id])
    if @event == nil
      redirect_to root_url, notice: "This event does not exist."
    elsif !(@event.private ? isInvited(@event.id, current_user.id) : true)
      redirect_to root_url, notice: "You do not have the correct permissions to comment on this event."
    else
      @c = @event.comments.build(comment_params)
      @c.save
      #inform owner of event that there's a new comment
      @owner = User.find_by(id: @event.user_id)
      @n = @owner.notifications.build(:user_id => @owner, :title => current_user.username.to_s + " has commented on your event.", :desc => current_user.username.to_s + ' is awaiting your response.', :sender_id => @event.id, :notification_type => 4)
      @n.save
      redirect_to "/events/" + @event.id.to_s + "#comments", notice: "Your comment has been posted."
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    isadmin
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @eventid = @comment.event_id
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to "/events/" + @eventid.to_s + "#comments", notice: 'Comment was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:text, :user_id, :event_id)
    end
end
