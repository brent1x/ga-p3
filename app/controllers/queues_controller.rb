class QueuesController < ApplicationController

  before_action :confirm_logged_in

  def index
    @user = User.find session[:user_id]
    @cues = Cue.all
  end

  def new
    @cue = Cue.new
    # @rest = Restaurant.new
    @restaurant = Restaurant.all
    @dropdown_arr = []
    @restaurant.each do |f|
      @dropdown_arr.push(f.name)
    end

  end

  def create
    user = User.find session[:user_id]
    @cue = Cue.create cue_params
    user.cues << @cue

    user = User.find session[:user_id]
    rest_params = {}
    rest_params["restaurant_id"] = Restaurant.find_by(name: cue_params["rests"]).id
    rest_params["user_id"] = session[:user_id]
    rest_params["cue_id"] = User.find(session[:user_id]).cues[0].id
    rest_params["start_date"] = cue_params["start_date(1i)"] + "-" + cue_params["start_date(2i)"] + "-" + cue_params["start_date(3i)"]
    rest_params["end_date"] = cue_params["end_date(1i)"] + "-" + cue_params["end_date(2i)"] + "-" + cue_params["end_date(3i)"]
    rest_params["start_time"] = cue_params["start_time(4i)"] + ":" + cue_params["start_time(5i)"] + ":00"
    rest_params["end_time"] = cue_params["end_time(4i)"] + ":" + cue_params["end_time(5i)"] + ":00"
    rest_params["covers"] = cue_params["covers"]

    @cue_res = CueRestaurant.new rest_params
    if @cue_res.save

      puts "Saved successfully"
      Crawler.first_crawl @cue_res
      redirect_to home_path
    else
      puts "not saved"
      render :new
    end
  end

  def destroy
    @user = User.find session[:user_id]
    @cue = Cue.find(params[:id])
    @cue.destroy
    if @user.cues.empty?
          redirect_to new_queue_path
        else
           redirect_to home_path
    end
  end

  ########## REMOVING EDIT & SHOW CAPABILITIES – USER CAN ONLY ADD OR DESTROY CUES ##########

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

    params.require(:cue).permit(:user_id, :rests, :start_date, :end_date, :start_time, :end_time, :covers)
  end

  def restaurant_params
    params.require(:restaurant).permit(:id)
  end
 end
