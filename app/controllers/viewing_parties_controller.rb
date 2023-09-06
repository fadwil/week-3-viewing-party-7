class ViewingPartiesController < ApplicationController
  # def new
  #   if session[:user_id]
  #     @user = User.find(session[:user_id])
  #     @movie = Movie.find(params[:movie_id])
  #   else
  #     flash[:error] = "You must be logged in or registered to create a movie party."
  #     redirect_to movie_path(@movie.id, @user.id)
  #   end
  # end

  # Could not make the above work because the story asks for a user to not be logged in, 
  # yet to create a viewing party I would need a user id 


  def new
    if current_user == nil
      flash[:error] = "You must be logged in or registered to create a movie party."
      redirect_to user_not_logged_in_path
    end
  end
end

