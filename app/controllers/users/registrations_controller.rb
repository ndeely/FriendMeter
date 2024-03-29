# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
   before_action :configure_sign_up_params, only: [:create]
   before_action :configure_account_update_params, only: [:update]
   include EventsHelper #to use deleteAll / deleteEventData methods
   include NotificationsHelper #to use deleteEventNotifications method

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  def destroy
    @cu = User.find_by(id: current_user.id)
    deleteAll(@cu.events)
    deleteAll(@cu.notifications)
    deleteAll(Notification.where(notification_type: 1, sender_id: @cu.id))
    deleteAll(Notification.where(notification_type: 2, sender_id: @cu.id))
    deleteAll(Attending.where(user_id: @cu.id))
    deleteAll(Comment.where(user_id: @cu.id))
    deleteAll(Review.where(user_id: @cu.id))
    deleteAll(Friend.where(user_id: @cu.id))
    deleteAll(Friend.where(friend_id: @cu.id))
    
    #delete account with devise method
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :fname, :lname, :avatar, :bio, :street, :city, :state, :country, :lat, :lng])
   end

  # If you have extra params to permit, append them to the sanitizer.
   def configure_account_update_params
     devise_parameter_sanitizer.permit(:account_update, keys: [:username, :fname, :lname, :avatar, :bio, :street, :city, :state, :country, :lat, :lng])
   end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
