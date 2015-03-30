class QueuesController < ApplicationController

  before_action :confirm_logged_in

  def index
    @user = User.find session[:user_id]
    @cues = Cue.all

  end

  def new
    @cue = Cue.new
  end

  def create
    user = User.find session[:user_id]
    @cue = Cue.create cue_params
    if @cue.save
      cue.restaurants << @restaurant
      user.cues << @cue
      redirect_to queues_path(session[:user_id]), flash: {success: "New queue added."}
    else
      render :new
    end
  end


  def destroy
    @cue.destroy
    redirect_to queues_path(session[:user_id])
  end

  ########## REMOVING EDIT & SHOW CAPABILITIES – USER CAN ONLY ADD OR DESTROY CUES ##########

  # def show
  #   @cue = Cue.find(params[:id])
  # end

  # def edit
  #   @cue = Cue.find(params[:id])
  # end

  # def update
  #   @cue = Cue.find(params[:id])
  #   @cue.update_attributes(cue_params)
  #   if @cue.save
  #     redirect_to home_path
  #   else
  #     render :edit
  #   end
  # end

private
  def cue_params
    params.require(:cue).permit(:user_id, :name, :restaurants, :start_date, :end_date, :start_time, :end_time)
  end

  def restaurant_params
    params.require(:restaurant).permit(:id)
  end
end
