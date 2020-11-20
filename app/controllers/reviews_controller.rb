class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  include PermissionsHelper
  include EventsHelper

  # GET /reviews
  # GET /reviews.json
  def index
    isadmin
    @reviews = Review.all
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    isadmin
  end

  # GET /reviews/new
  def new
    isadmin
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
    isadmin
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @event = Event.find_by(id: review_params[:event_id])
    if @event == nil
      redirect_to root_url, notice: "This event does not exist."
    elsif !(@event.private ? isInvited(@event.id, current_user.id) : true)
      redirect_to root_url, notice: "You do not have the correct permissions to review this event."
    else
      @r = @event.reviews.build(review_params)
      @r.save
      #inform owner of event that there's a new review
      @owner = User.find_by(id: @event.user_id)
      @n = @owner.notifications.build(:user_id => @owner.id, :title => "New Event Review", :desc => current_user.username.to_s + " has reviewed your event " + @event.name + ".", :sender_id => @event.id, :notification_type => 4)
      @n.save
      redirect_to "/events/" + @event.id.to_s + "#reviews", notice: "Your review has been posted."
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    isadmin
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @eventid = @review.event_id
    @review.destroy
    respond_to do |format|
      format.html { redirect_to "/events/" + @eventid.to_s + "#reviews", notice: 'Review was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:text, :rating, :user_id, :event_id)
    end
end
