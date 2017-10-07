class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
  end

  def create
    if login(params[:email], params[:password], params[:remember_me])
      if current_user.role == "Admin"
        flash[:success] = '(Admin) Welcome, ' + current_user.name
        redirect_to admin_index_path
      elsif current_user.role == "Judge"
        flash[:success] = '(Judge) Welcome, ' + current_user.name
        redirect_to participate_index_path
      else
        logout
        flash.now[:warning] = 'E-mail and/or password is incorrect.'
        render 'new'
      end
    else
      flash.now[:warning] = 'E-mail and/or password is incorrect.'
      render 'new'
    end
  end

  def destroy
    logout
    flash[:success] = 'Logged Out'
    redirect_to log_in_path
  end
end