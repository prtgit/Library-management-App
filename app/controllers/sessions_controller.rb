class SessionsController < ApplicationController
  include SessionsHelper
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        log_in user, params[:session]
        redirect_to user
        return
      end
    else
      flash.now[:error] = 'Improper credentials, kindly retry with correct credentials'
      redirect_to(sessions_new_path)
      return
    end

  def destroy
    log_out
    redirect_to root_url
  end
end
