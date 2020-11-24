class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  include PermissionsHelper
  include NotificationsHelper

  # GET /notifications
  # GET /notifications.json
  def index
    @b1 = isadmin
    @ns = @b1 ? Notification.all : current_user.notifications
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
    checkadmin
  end

  # GET /notifications/new
  def new
    checkadmin
    @notification = Notification.new
  end

  # GET /notifications/1/edit
  def edit
    checkadmin
  end

  # POST /notifications
  # POST /notifications.json
  def create
    @notification = Notification.new(notification_params)

    respond_to do |format|
      if @notification.save
        format.html { redirect_to @notification, notice: 'Notification was successfully created.' }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to @notification, notice: 'Notification was successfully updated.' }
        format.json { render :show, status: :ok, location: @notification }
      else
        format.html { render :edit }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  #delete all notifications ('/notifications/:uid/9')
  def deleteAll
    if current_user.id != params[:uid].to_i
      redirect_to "/notifications", notice: "You cannot delete someone else's notifications."
    else
      deleteUserNotifications(params[:uid])
    end
  end

  #delete all notifications for specific event ('/notifications/:eid/8')
  def deleteForEvent
    deleteEventNotifications(current_user.id, params[:eid])
  end

  #accept friend request ('/notifications/:id/1')
  def acceptFriend
    signedin
    @n = Notification.find_by(id: params[:id])
    if @n != nil && current_user.id == @n.user_id
      @user1 = User.find_by(id: @n.user_id)
      @user2 = User.find_by(id: @n.sender_id)
      @friend12 = @user1.friends.build(:user_id => @user1.id, :friend_id => @user2.id)
      @friend12.save
      @friend21 = @user2.friends.build(:user_id => @user2.id, :friend_id => @user1.id)
      @friend21.save
      @n.destroy #delete notification after
      respond_to do |format|
        format.html { redirect_to notifications_url, notice: 'Friend request accepted.' }
        format.json { head :no_content }
      end
    else
      redirect_to notifications_url
    end
  end

  #accept event invite ('/notifications/:id/3')
  def acceptEvent
    signedin
    @n = Notification.find_by(id: params[:id])
    if @n != nil && current_user.id == @n.user_id
      @user = User.find_by(id: @n.user_id)
      @event = Event.find_by(id: @n.sender_id)
      @a = @event.attending.build(:event_id => @event.id, :user_id => @user.id)
      @a.save
      @n.destroy #delete notification after
      respond_to do |format|
        format.html { redirect_to notifications_url, notice: 'Invite accepted.' }
        format.json { head :no_content }
      end
    else
      redirect_to notifications_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notification_params
      params.require(:notification).permit(:user_id, :title, :desc, :sender_id)
    end
end
