class ProfilesController < ApplicationController
  include PermissionsHelper
  include FriendsHelper
  include EventsHelper
  include ReviewsHelper
  include ProfilesHelper
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles
  # GET /profiles.json
  def index
    checkadmin
    @profiles = Profile.all
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    checkadmin
  end

  # GET /profiles/new
  def new
    signedin
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
    signedin
  end

  # POST /profiles
  # POST /profiles.json
  def create
    signedin
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    signedin
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    signedin
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # get user's profile page ("/users/{id}")
  def profile
    require 'will_paginate/array'

    @cuid = isSignedIn ? current_user.id : nil
    @b1 = isadmin
    @creator = User.find_by(id: params[:id])
    if @creator == nil
      redirect_to root_url, notice: "This user does not exist"
    else
      #handle friend requests
      @friend = areFriends(params[:id], @cuid)

      @b2 = @b1 || (@cuid == @creator.id)
      @b3 = @b2 || @friend
      @name = getName(@cuid, @creator.id)
      @allevents = @creator.events
      @events = []
      @endedEvents = []
      @allevents.each do |e|
        #check if user is invited/attending
        @invited = isInvited(e.id, @cuid)
        @attending = isAttending(e.id, @cuid)

        if (!e.private || @b2 || @invited || @attending)
          if !eventEnded(e.id)
            @events.push(e)
          else
            @endedEvents.push(e)
          end
        end
      end
      @events = @events.paginate(page: params[:page1], per_page: 6)
      @userEvents = getUnfinishedEvents(@cuid).paginate(page: params[:page2], per_page: 6)
      @endedEvents = @endedEvents.paginate(page: params[:page3], per_page: 6)
      #check friend request status
      @frs = friendRequestSent(@cuid, @creator.id)
    end
  end

  #add user id as friend from id2 ('/users/:id/:id2')
  def friend
    signedin
    if current_user.id.to_s != params[:id2]
      redirect_to "/users/" + params[:id], notice: "You do not have permissions for this action."
    elsif areFriends(params[:id], params[:id2])
      redirect_to "/users/" + params[:id], notice: "You are already friends with this user."
    else
      if friendUsers(params[:id2], params[:id])
        redirect_to "/users/" + params[:id], notice: "Your friend request has been sent."
      else
        redirect_to "/users/" + params[:id], notice: "There was a problem processing your request."
      end
    end
  end

  #unfriend user ('/users/:id/:id2/1')
  def unfriend
    signedin
    if current_user.id.to_s != params[:id2]
      redirect_to "/users/" + params[:id], notice: "You do not have permissions for this action."
    elsif !areFriends(params[:id], params[:id2])
      redirect_to "/users/" + params[:id], notice: "You are not friends with this user."
    else
      if unfriendUsers(params[:id2], params[:id])
        redirect_to "/users/" + params[:id], notice: "You have successfully unfriended this user."
      else
        redirect_to "/users/" + params[:id], notice: "There was a problem processing your request."
      end
    end
  end

  #show reviews for user ('/user/:uid/reviews')
  def reviews
    @u = User.find_by(id: params[:uid])
    @rs = getUserReviews(params[:uid])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.fetch(:profile, {})
    end
end
