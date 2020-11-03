class AttendingsController < ApplicationController
  before_action :set_attending, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  include PermissionsHelper

  # GET /attendings
  # GET /attendings.json
  def index
    @b1 = isadmin
    @attendings = @b1 ? Attending.all : current_user.notifications
  end

  # GET /attendings/1
  # GET /attendings/1.json
  def show
  end

  # GET /attendings/new
  def new
    checkadmin
    @attending = Attending.new
  end

  # GET /attendings/1/edit
  def edit
    checkadmin
  end

  # POST /attendings
  # POST /attendings.json
  def create
    @attending = Attending.new(attending_params)

    respond_to do |format|
      if @attending.save
        format.html { redirect_to @attending, notice: 'Attending was successfully created.' }
        format.json { render :show, status: :created, location: @attending }
      else
        format.html { render :new }
        format.json { render json: @attending.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendings/1
  # PATCH/PUT /attendings/1.json
  def update
    respond_to do |format|
      if @attending.update(attending_params)
        format.html { redirect_to @attending, notice: 'Attending was successfully updated.' }
        format.json { render :show, status: :ok, location: @attending }
      else
        format.html { render :edit }
        format.json { render json: @attending.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendings/1
  # DELETE /attendings/1.json
  def destroy
    @attending.destroy
    respond_to do |format|
      format.html { redirect_to attendings_url, notice: 'Attending was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attending
      @attending = Attending.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attending_params
      params.require(:attending).permit(:event_id, :user_id)
    end
end
