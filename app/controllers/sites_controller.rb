class SitesController < ApplicationController

  def about
    ### LINES 5 & 6 ARE NOT NEEDED IF WE ARE NOT REQUIRING USER TO BE LOGGED IN TO SEE THE ABOUT PAGE
    # user_id = session[:user_id]
    # @found_user = User.find(user_id)

    # redirect_to about_path

  end

  def menu
    user_id = session[:user_id]
    @found_user = User.find(user_id)
    redirect_to menu_path
  end

  #get the add restuarant page
  def add
    @restaurant = Restaurant.new
  end

  #add a restaurant to the rest. database
  def add_restaurant
  restaurant_info = Open.find_restaurant params[:restaurant][:name], params[:restaurant][:city], params[:restaurant][:state], params[:restaurant][:open_table_id]
    if restaurant_info
      message = Crawler.url_check  restaurant_info
      message
    else
    flash[:notice] = "Restaurant not found"
    end
    redirect_to cues_path
  end


end
