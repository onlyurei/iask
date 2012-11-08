class UsersController < ApplicationController
  skip_before_filter :login_required
  
  # GET /users/new
  # GET /users/new.xml
  # render new.rhtml
  def new
  end
  
  # GET /users/students
  # GET /users/students.xml
  def students
    if current_user.is_admin?
      @students= User.find(:all, :conditions => "is_teacher = '0' and is_admin = '0'")
      respond_to do |format|
        format.xml  { render :xml => @students }
      end
    else
      respond_to do |format|
        format.xml  { render :text => "error" }
      end
    end
  end
  
  # GET /users/teachers
  # GET /users/teachers.xml
  def teachers
    if current_user.is_admin?
      @teachers= User.find(:all, :conditions => "is_teacher = '1' and is_admin = '0'")
      respond_to do |format|
        format.xml  { render :xml => @teachers }
      end
    else
      respond_to do |format|
        format.xml  { render :text => "error" }
      end
    end
  end
  
  # GET /users/1/list_courses
  # GET /users/1/list_courses.xml
  def list_courses
    if current_user.is_admin?
      @user = User.find(params[:id])
      @courses = @user.courses
      respond_to do |format|
        format.xml  { render :xml => @courses }
      end
    else
      respond_to do |format|
        format.xml  { render :text => "error" }
      end
    end
  end
  
  # POST /users
  # POST /users.xml
  def create
    if current_user.is_admin?
      cookies.delete :auth_token
      # protects against session fixation attacks, wreaks havoc with 
      # request forgery protection.
      # uncomment at your own risk
      # reset_session
      @user = User.new(params[:user])
      @user.save!
      #self.current_user = @user
      respond_to do |format|
        format.html do
          redirect_back_or_default('/')
          flash[:notice] = "Thanks for signing up!"
        end
        format.xml { render :xml => @user.to_xml }
      end
    else
      respond_to do |format|
        format.xml { render :text => "error" }
      end
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.html { render :action => 'new' }
      format.xml do
        unless @user.errors.empty?
          render :xml => @user.errors.to_xml_full
        else
          render :text => "error"
        end
      end
    end
  end
  
 #PUT /users/1
 #PUT /users/1.xml
 def update
   if current_user.is_admin?
     @user = User.find(params[:id])
     @user.update_attributes!(params[:user])
     respond_to do |format|
       format.xml { render :xml => @user.to_xml }
     end
   else  
     respond_to do |format|
       format.xml { render :text => "error" }
     end
   end
 rescue ActiveRecord::RecordInvalid
   respond_to do |format|
     format.xml do
       unless @user.errors.empty?
         render :xml => @user.errors.to_xml_full
       else
         render :text => "error"
       end
     end
   end
 end
 
 #PUT /users/1/update_password
 #PUT /users/1/update_password.xml
  def update_password
    @user = User.authenticate(params[:login], params[:current_password])
    if @user.nil?
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :text => "error" }
      end
    else
      respond_to do |format|
        if @user.update_attributes!(params[:user])
          flash[:notice] = 'Your account was successfully updated.'
          format.html { redirect_to(@user) }
          format.xml  { render :text => "success"}
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @user.errors,
            :status => :unprocessable_entity }
        end
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # PUT /users/1/add_course
  # PUT /users/1/add_course.xml
  def add_course
    if current_user.is_admin?
      @user = User.find(params[:id])
      @course = Course.find_by_official_id(params[:course_official_id])
      if @course.nil?
        respond_to do |format|
           format.xml  { render :text => "course_not_exist" }
        end
        return
      end
      if !@user.is_admin?
        if @user.courses.find_by_id(@course.id).nil?
          @user.courses << @course
        else
          respond_to do |format|
            format.xml  { render :text => "course_exists" }
          end
          return
        end
      end
      respond_to do |format|
        format.xml  { render :xml => @course.to_xml }
      end
    else
      respond_to do |format|
        format.xml  { render :text => "error" }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    if current_user.is_admin?
      @user = User.find(params[:id])
      if @user.is_teacher?
        Query.destroy_all(["teacher_id = ?", @user.id])
      else  
        Query.destroy_all(["student_id = ?", @user.id])
      end
      @user.destroy
      respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { render :xml => "success" }
      end
    else
      respond_to do |format|
        flash[:notice] = 'You cannot do this.'
        format.html { redirect_to(@user) }
        format.xml  { render :text => "error" }
      end
    end
  end
  
  # DELETE /users/destroy_by_official_id
  # DELETE /users/destroy_by_official_id
  def destroy_by_official_id
    if current_user.is_admin?
      @user = User.find_by_official_id(params[:official_id])
      if @user.nil?
        respond_to do |format|
          format.xml  { render :text => "error" }
        end
        return
      end
      if @user.is_teacher?
        Query.destroy_all(["teacher_id = ?", @user.id])
      else  
        Query.destroy_all(["student_id = ?", @user.id])
      end
      @user.destroy
      respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { render :xml => "success" }
      end
    else
      respond_to do |format|
        flash[:notice] = 'You cannot do this.'
        format.html { redirect_to(@user) }
        format.xml  { render :text => "error" }
      end
    end  
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

end
