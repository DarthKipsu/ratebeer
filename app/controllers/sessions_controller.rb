class SessionsController < ApplicationController
  def new
  end

  def create_oauth
    user = User.github(env['omniauth.auth'].info)
    if user
      login user
    else
      redirect_to :back, alert: "GitHub authentication failed"
    end
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      login user
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

  def login(user)
    if user.suspended
      redirect_to :back, notice: "Your account is frozen, please contact admin"
    else
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    end
  end
end
