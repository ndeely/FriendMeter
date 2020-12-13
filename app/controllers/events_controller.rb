class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  include PermissionsHelper
  include EventsHelper
  include FriendsHelper
  include ReviewsHelper
  include NotificationsHelper

  require 'will_paginate/array'

  # GET /events
  # GET /events.json
  def index
    # TODO remove events due to distance/ sort by distance
    @cuid = isSignedIn ? current_user.id : nil
    @b1 = isadmin
    # unfiltered events
    @ufevents = (params[:search] == nil) ? (params[:nearby] == nil ? Event.all.order('date') : nearbyEvents) : searchEvents(params[:search])
    @events = []
    @ufevents.each do |event|

      # work out if the user is invited or attending
      @invited = isInvited(event.id, @cuid)
      @attending = isAttending(event.id, @cuid)

      if !eventEnded(event.id) && (@b1 || !event.private || (user_signed_in? && event.user_id == @cuid) || @invited || @attending)
        @events.push(event)
      end
    end
    @events = @events.paginate(page: params[:page], per_page: 6)
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @cuid = isSignedIn ? current_user.id : nil
    @creator = User.find(Event.find(params[:id]).user_id)
    @b2 = isadmin || @cuid == @creator.id
    @name = getName(@cuid, @creator.id)
    @attending = Event.find(params[:id]).attendings.paginate(page: params[:page], per_page: 8)
    if Event.find(params[:id]).private && !(@b2 || isInvited(params[:id], @cuid) || isAttending(params[:id], @cuid))
      redirect_to events_url
    end
    @isAttending = isAttending(params[:id], @cuid)

    #comments and reviews
    @isi = isSignedIn
    @comments = Event.find(params[:id]).comments
    @comment = Comment.new
    @reviews = Event.find(params[:id]).reviews
    @review = Review.new

    #get gon lat/lngs
    if isSignedIn
      gon.cu_lat = current_user.lat
      gon.cu_lng = current_user.lng
    end
    gon.e_lat = Event.find_by(id: params[:id]).lat
    gon.e_lng = Event.find_by(id: params[:id]).lng
  end

  # GET /events/new
  def new
    signedin
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    signedin
  end

  # POST /events
  # POST /events.json
  def create
    signedin
    if Date.today > Date.civil(event_params["date(1i)"].to_i, event_params["date(2i)"].to_i, event_params["date(3i)"].to_i)
      redirect_to "/events/new", notice: "Invalid date. You cannot create an event occurring in the past."
    else
      @event = current_user.events.build(event_params)
      setAvatar(@event, params[:avatar])

      respond_to do |format|
        if @event.save
          format.html { redirect_to @event, notice: 'Event was successfully created.' }
          format.json { render :show, status: :created, location: @event }
        else
          format.html { render :new }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    signedin
    setAvatar(@event, params[:avatar])
    if Date.today > Date.civil(event_params["date(1i)"].to_i, event_params["date(2i)"].to_i, event_params["date(3i)"].to_i)
      redirect_to "/events/" + @event.id.to_s + "/edit", notice: "Invalid date. This date has already passed."
    else
      respond_to do |format|
        if @event.update(event_params)
          format.html { redirect_to @event, notice: 'Event was successfully updated.' }
          format.json { render :show, status: :ok, location: @event }
        else
          format.html { render :edit }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    signedin
    if !eventEnded(@event.id) || isadmin
      deleteEventData(@event.id)

      @event.destroy
      respond_to do |format|
        format.html { redirect_to events_url, notice: 'Event was successfully deleted.' }
        format.json { head :no_content }
      end
    end
  end

  #confirm attendance to event from event ('/events/:eid/1')
  def attend
    @cuid = isSignedIn ? current_user.id : nil
    if @cuid == nil
      redirect_to "/users/sign_in", notice: "You must be signed in to attend events."
    else
      @event = Event.find_by(id: params[:eid])
      if @event != nil && (@event.private ? (isInvited(@event.id, @cuid) || @event.user_id == @cuid) : true)
        if !isAttending(@event.id, @cuid)
          @attending = @event.attendings.build(:event_id => @event.id, :user_id => @cuid)
          @attending.save
          deleteNotificationIfExists(@event.id, @cuid)
          respond_to do |format|
            format.html { redirect_to "/events/" + @event.id.to_s, notice: 'Confirmed attendance.' }
            format.json { head :no_content }
          end
        else
          deleteNotificationIfExists(@event.id, @cuid)
          redirect_to "/events/" + @event.id.to_s, notice: "You are already attending this event."
        end
      else
        redirect_to "/events/", notice: "You cannot attend this event without an invite."
      end
    end
  end

  #unattend event from event ('/events/:eid/2')
  def unattend
    @cuid = isSignedIn ? current_user.id : nil
    if @cuid == nil
      redirect_to "/users/sign_in", notice: "You must be signed in to attend events."
    else
      @attending = Attending.find_by(event_id: params[:eid], user_id: @cuid)
      if @attending != nil
        @attending.destroy
        respond_to do |format|
          format.html { redirect_to "/events/" + params[:eid].to_s, notice: 'You are no longer attending this event.' }
          format.json { head :no_content }
        end
      else
        redirect_to "/events/" + params[:eid].to_s, notice: 'You were not attending this event.'
      end
    end
  end

  #send user an invite to an event ('/events/:eid/:uid/1')
  def invite
    sendEventInvite(params[:eid], params[:uid])
  end

  #accept invite to event ('/events/:eid/:uid/2')
  def acceptInvite
    signedin
    acceptEventInvite(params[:eid], params[:uid])
  end

  # GET /myevents
  # GET /myevents.json
  def myevents
    signedin
    require 'will_paginate/array'

    @cuid = isSignedIn ? current_user.id : nil
    @b1 = isadmin
    # unfiltered events
    @ufevents = Event.all.order('date')
    @events1 = [] #user events
    @events2 = [] #attending
    @events3 = [] #invited
    @events4 = [] #expired events created or attended
    @ufevents.each do |event|

      #user events
      @ue = (@cuid == event.user_id) && !eventEnded(event.id)
      # work out if the user is invited/attending, doesn't own the event, and the event isn't over
      @attending = isAttending(event.id, @cuid) && !eventEnded(event.id)
      @invited = isInvited(event.id, @cuid) && (@cuid != event.user_id) && !eventEnded(event.id)
      #past events
      @pe = eventEnded(event.id) && ((@cuid == event.user_id) || isAttending(event.id, @cuid))

      if @ue
        @events1.push(event)
      end
      if @attending
        @events2.push(event)
      end
      if @invited
        @events3.push(event)
      end
      if @pe
        @events4.push(event)
      end
    end
    @events1 = @events1.paginate(page: params[:page1], per_page: 6)
    @events2 = @events2.paginate(page: params[:page2], per_page: 6)
    @events3 = @events3.paginate(page: params[:page3], per_page: 6)
    @events4 = @events4.paginate(page: params[:page4], per_page: 6)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :description, :date, :time, :avatar, :private, :editable, :search, :street, :city, :state, :country, :lat, :lng)
    end
end
