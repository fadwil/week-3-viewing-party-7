class UsersController <ApplicationController 
  def new 
    @user = User.new()
  end 

  def show 
    if session[:user_id] 
      @user = User.find(session[:user_id])
    else
      flash[:error] = "You must be logged in or registered to access your dashboard."
      redirect_to root_path
    end
  end 

  def create 
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to "/dashboard"
    else  
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to register_path
    end 
  end 

  def login_form
  end

  def login_user
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to "/dashboard"
    else 
      flash[:error] = "Sorry, your credentials are bad."
      render :login_form
    end
  end

  def logout
    session.delete(:user_id)
    redirect_to root_path
  end

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 
end 