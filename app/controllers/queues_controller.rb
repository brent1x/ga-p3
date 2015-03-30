class QueuesController < ApplicationController

  def index
    @cue = Cue.all
  end

  def new
    @cue = Cue.new
  end

  def create
    @cue = Cue.create(cue_params)
    if @cue.save
      redirect_to home_path
    else
      render :new
    end
  end

  def show
    @cue = Cue.find(params[:id])
  end

  ### REMOVING EDIT CAPABILITIES

  # def edit
  #   @cue = Cue.find(params[:id])
  # end
  #
  # def update
  #   @cue = Cue.find(params[:id])
  #   @cue.update_attributes(cue_params)
  #   if @cue.save
  #     redirect_to home_path
  #   else
  #     render :edit
  #   end
  # end

  def destroy
    @cue = Cue.find(params[:id])
    @cue.destroy
    redirect_to home_path
  end

private
  def cue_params
    ### UPDATE
    params.require(:cue).permit(:id)
  end
end
