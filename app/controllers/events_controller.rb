class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  include PermissionsHelper

  # GET /events
  # GET /events.json
  def index
    # TODO remove events due to distance/ sort by distance
    require 'will_paginate/array'

    @b1 = isadmin
    # unfiltered events
    @ufevents = Event.all.order('date')
    @events = []
    @ufevents.each do |event|

      # work out if the user is invited
      @invited = isInvited(event.id, current_user.id)

      if @b1 || !event.private || (user_signed_in? && event.user_id == current_user.id) || @invited
        @events.push(event)
      end
    end
    @events = @events.paginate(page: params[:page], per_page: 6)
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @creator = User.find(Event.find(params[:id]).user_id)
    @b2 = isadmin || (current_user.id == @creator.id)
    @name = getName(current_user.id, @creator.id)
    @attending = Event.find(params[:id]).attending
    if Event.find(params[:id]).private && !(@b2 || isInvited(params[:id], current_user.id) || isAttending(params[:id], current_user.id))
      redirect_to events_url
    end
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
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

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    setAvatar(@event, params[:avatar])
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

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #confirm attendance to event from event ('/events/:eid/1')
  def attend
    signedin
    @event = Event.find_by(id: params[:id])
    if @event != nil && !isAttending(@event.id, current_user.id)
      @attending = @event.attending.build(:event_id => @event.id, :user_id => current_user.id)
      @attending.save
      respond_to do |format|
        format.html { redirect_to event_url, notice: 'Confirmed attendance.' }
        format.json { head :no_content }
      end
    else
      redirect_to notifications_url
    end
  end

  #send user an invite to an event ('/events/:eid/:uid/1')
  def invite
    signedin
    @event = Event.find_by(id: params[:eid])
    @user = User.find_by(id: params[:uid])
    if @event != nil && @user != nil && !isAttending(@event.id, @user.id) && !isInvited(@event.id, @user.id)
      @notification = @user.notifications.build(:user_id => @user.id, :title => 'You have been invited to an event!', :desc => 'The sender is awaiting your response.', :sender_id => @event.id, :notification_type => 3)
      @notification.save
      respond_to do |format|
        format.html { redirect_to '/users/' + @user.id.to_s, notice: 'Invite Sent.' }
        format.json { head :no_content }
      end
    else
      redirect_to '/users/' + @user.id.to_s
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :description, :date, :time, :avatar, :private, :editable)
    end
end
