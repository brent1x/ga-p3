class SitesController < ApplicationController

  def about
    ### LINES 5 & 6 ARE NOT NEEDED IF WE ARE NOT REQUIRING USER TO BE LOGGED IN TO SEE THE ABOUT PAGE
    # user_id = session[:user_id]
    # @found_user = User.find(user_id)
    redirect_to about_path
  end

  def menu
    user_id = session[:user_id]
    @found_user = User.find(user_id)
    redirect_to menu_path
  end

end
