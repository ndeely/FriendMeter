class FriendsController < ApplicationController
  before_action :set_friend, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  include PermissionsHelper
  include StaticPagesHelper
  include FriendsHelper

  # GET /friends
  # GET /friends.json
  def index
    @b1 = isadmin
    @friends = @b1 ? Friend.all : (params[:search] == nil ? current_user.friends : searchFriends(params[:search]))
    @friends.sort_by{ |f| [User.find_by(id: f.friend_id).fname, User.find_by(id: f.friend_id).lname] }
  end

  # GET /friends/1
  # GET /friends/1.json
  def show
    checkadmin
  end

  # GET /friends/new
  def new
    checkadmin
    @friend = Friend.new
  end

  # GET /friends/1/edit
  def edit
    checkadmin
  end

  # POST /friends
  # POST /friends.json
  def create
    @friend = Friend.new(friend_params)

    respond_to do |format|
      if @friend.save
        format.html { redirect_to @friend, notice: 'Friend was successfully created.' }
        format.json { render :show, status: :created, location: @friend }
      else
        format.html { render :new }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /friends/1
  # PATCH/PUT /friends/1.json
  def update
    respond_to do |format|
      if @friend.update(friend_params)
        format.html { redirect_to @friend, notice: 'Friend was successfully updated.' }
        format.json { render :show, status: :ok, location: @friend }
      else
        format.html { render :edit }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friends/1
  # DELETE /friends/1.json
  def destroy
    @friend.destroy
    respond_to do |format|
      format.html { redirect_to friends_url, notice: 'Friend was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friend
      @friend = Friend.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friend_params
      params.require(:friend).permit(:user_id, :friend_id, :search)
    end
end
