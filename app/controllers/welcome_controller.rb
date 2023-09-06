class WelcomeController < ApplicationController 
  def index 
    if current_user
      @users = User.all
    else
      @users = []
    end
  end 
end 