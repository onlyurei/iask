# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  skip_before_filter :login_required
  
  # GET /session/new
  # GET /session/new.xml
  # render new.rhtml
  def new
  end

  # POST /session
  # POST /session.xml
  def create
    self.current_user =
      User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = {
          :value => self.current_user.remember_token ,
          :expires =>
            self.current_user.remember_token_expires_at }
      end
      respond_to do |format|
        format.html do
          redirect_back_or_default('/')
          flash[:notice] = "Logged in successfully"
        end
        format.xml {render :xml => self.current_user.to_xml}
      end
    else
      respond_to do |format|
        format.html {render :action => 'new'}
        format.xml {render :text => "badlogin"}
      end
    end
  end

  # DELETE /session
  # DELETE /session.xml
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    respond_to do |format|
      format.html do
        flash[:notice] = "You have been logged out."
        redirect_back_or_default('/')
      end
      format.xml {render :text => "success"}
    end
  end
end
