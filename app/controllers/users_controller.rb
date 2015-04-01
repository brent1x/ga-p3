class UsersController < ApplicationController
  def login
  	@user = User.new
  end

  def signup
  	@user = User.new
  end

  def account
  	@user = User.find(session[:user_id])
  end

  def home
  	@user = User.find(session[:user_id])
    @cue = @user.cues
    @cues = Cue.all


  end


  def create
   @user = User.new user_params
    if @user.save
      	redirect_to login_path
    else
      	render :signup
    end
  end

  def attempt_login

  	if User.check_if_user_exists params[:user][:email]

  		@user = User.find_user params[:user][:email]
  		if @user.check_password params[:user][:password]
  		session[:user_id] = @user.id
		session[:email] = @user.email
		session[:first_name] = @user.first_name
		session[:last_name] = @user.last_name
  			flash[:notice] = "Welcome #{session[:first_name]}"
        if @user.cues.empty?
          redirect_to new_queue_path
        else
  			   redirect_to home_path
        end
  		else

  			flash[:notice] = "Incorrect Password"
        	redirect_to login_path
  		end
  	else

      flash[:notice] = "Username not found"
      redirect_to login_path
    end
  end

  def logout
    session[:user_id] = nil
    session[:username] = nil
    flash[:notice] = "You are now logged out."
    redirect_to login_path
  end

private
def user_params
params.require(:user).permit(:first_name,:last_name,:email,:phone_number,:password)
end

end