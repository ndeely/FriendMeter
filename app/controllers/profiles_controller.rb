class ProfilesController < ApplicationController
  include PermissionsHelper
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

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
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  # POST /profiles.json
  def create
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
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # get user's profile page
  def profile
    @b1 = isadmin
    @creator = User.find_by(id: params[:id])

    #handle friend requests
    @friend = areFriends(@creator.id, current_user.id)

    @b2 = @b1 || (current_user.id == @creator.id)
    @b3 = @b2 || @friend
    @name = getName(current_user.id, @creator.id)
    @allevents = @creator.events
    @events = []
    @allevents.each do |event|
      #check if user is invited/attending
      @invited = isInvited(event.id, current_user.id)
      @attending = isAttending(event.id, current_user.id)

      if !event.private || @b2 || @invited || @attending
        @events.push(event)
      end
    end
    #check friend request status
    @frs = friendRequestSent(current_user.id, @creator.id, params[:id2])
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
