class CoursesController < ApplicationController
  # GET /courses
  # GET /courses.xml
  def index
    @courses = current_user.courses
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @courses }
    end
  end
  
  # GET /courses/list_all
  # GET /courses/list_all.xml
  def list_all
    if current_user.is_admin?
      @courses = Course.find(:all)
      respond_to do |format|
        format.xml  { render :xml => @courses }
      end
    else
      respond_to do |format|
        format.xml  { render :text => "error" }
      end
    end
  end

  # GET /courses/1
  # GET /courses/1.xml
  def show
    @course = current_user.courses.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # GET /courses/1/list_entries
  # GET /courses/1/list_entries.xml
  def list_entries
    @course = current_user.courses.find(params[:id])
    @entries = @course.entries
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entries }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # GET /courses/1/list_queries
  # GET /courses/1/list_queries.xml
  def list_queries
    @course = current_user.courses.find(params[:id])
    @queries = @course.queries
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @queries }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # GET /courses/1/list_teachers
  # GET /courses/1/list_teachers.xml
  def list_teachers
    if current_user.is_admin?
      @course = Course.find(params[:id])
    else
      @course = current_user.courses.find(params[:id])
    end
    @users = @course.users
    @teachers = Array.new
    @users.each do |x|
      if x.is_teacher?
        @teachers << x
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teachers }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # GET /courses/1/list_students
  # GET /courses/1/list_students.xml
  def list_students
    if current_user.is_admin?
      @course = Course.find(params[:id])
    else
      @course = current_user.courses.find(params[:id])
    end
    @users = @course.users
    @students = Array.new
    @users.each do |x|
      if !x.is_teacher?
        @students << x
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # GET /courses/1/list_keywords
  # GET /courses/1/list_keywords.xml
  def list_keywords
    @course = current_user.courses.find(params[:id])
    @entries = @course.entries
    @keywords = Array.new
    @entries.each do |e|
      @keywords += e.keywords
    end
    @keywords.uniq!
    @keywords = @keywords.sort_by {|x| x.value}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @keywords }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  # POST /courses
  # POST /courses.xml
  def create
    if current_user.is_admin?
      @course = Course.new(params[:course])
      @course.save!
      respond_to do |format|
        format.html do
          flash[:notice] = 'Course was successfully created.'
          redirect_to(@course)
        end
        format.xml  { render :xml => @course.to_xml }
      end
    else
      respond_to do |format|
        flash[:notice] = 'You cannot do this.'
        format.html { redirect_to(@course) }
        format.xml  { render :text => "error" }
      end
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.html {render :action => 'new'}
      format.xml {render :text => "official_id_exists"}
    end
  end
  
  # POST /courses/1/create_entry
  # POST /courses/1/create_entry.xml
  def create_entry
    if current_user.is_teacher?
      @course = current_user.courses.find(params[:id])
      @entry = current_user.entries.create(params[:entry])
      @keyword = Keyword.find_by_value(params[:keyword_value])
      if @keyword.nil?
        @keyword = Keyword.create(params[:keyword])
      end
      @relevance = Relevance.new(params[:relevance])
      @relevance.entry = @entry
      @relevance.keyword = @keyword
      @relevance.save
      current_user.entries_sum += 1
      current_user.save!
      respond_to do |format|
        format.html do
          flash[:notice] = 'Entry was successfully created.'
          redirect_to(@entry) 
        end
        format.xml  { render :text => "success" }
      end
    else
      respond_to do |format|
        flash[:notice] = 'You cannot do this.'
        format.html { redirect_to(@course) }
        format.xml  { render :text => "error" }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # POST /courses/1/create_query
  # POST /courses/1/create_query.xml
  def create_query
    if !current_user.is_teacher?
      @course = current_user.courses.find(params[:id])
      @query = @course.queries.build(params[:query])
      @query.student_id = current_user.id
      @query.teacher_id = params[:teacher_id]
      respond_to do |format|
        if @query.save
          current_user.entries_sum += 1
          current_user.save!
          flash[:notice] = 'Query was successfully created.'
          format.html { redirect_to(@query) }
          format.xml  { render :text => "success" }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @query.errors, :status => :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        flash[:notice] = 'You cannot do this.'
        format.html { redirect_to(@course) }
        format.xml  { render :text => "error" }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # POST /courses/1/create_queries
  # POST /courses/1/create_queries.xml
  def create_queries
    if !current_user.is_teacher?
      @course = current_user.courses.find(params[:id])
      @teachers = @course.users.select {|x| x.is_teacher == true}
      @queries = Array.new
      @teachers.each do |t|
        @query = @course.queries.build(params[:query])
        @query.student_id = current_user.id
        @query.teacher_id = t.id
        @query.teacher_official_id = t.official_id
        @query.teacher_last_name = t.last_name
        @query.teacher_first_name = t.first_name
        @queries << @query
        @query.save!
      end
      current_user.entries_sum += 1
      current_user.save!
      respond_to do |format|
        flash[:notice] = 'Queries were successfully created.'
        format.html { redirect_to(@query) }
        format.xml  { render :text => "success" }
      end
    else
      respond_to do |format|
        flash[:notice] = 'You cannot do this.'
        format.html { redirect_to(@course) }
        format.xml  { render :text => "error" }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  # PUT /courses/1
  # PUT /courses/1.xml
  def update
    if current_user.is_admin?
      @course = Course.find(params[:id])
      respond_to do |format|
        if @course.update_attributes(params[:course])
          flash[:notice] = 'Course was successfully updated.'
          format.html { redirect_to(@course) }
          format.xml  { render :text => "success" }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @course.errors,
            :status => :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        flash[:notice] = 'You cannot do this.'
        format.html { redirect_to(@course) }
        format.xml  { render :text => "error" }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  # PUT /courses/1/add_user
  # PUT /courses/1/add_user.xml
  def add_user
    if current_user.is_admin?
      @course = Course.find(params[:id])
      @user = User.find_by_official_id(params[:user_official_id])
      if @user.nil?
        respond_to do |format|
            format.xml  { render :text => "user_not_exist" }
        end
        return
      end
      if !@user.is_admin?
        if @course.users.find_by_id(@user.id).nil?
          @course.users << @user
        else
          respond_to do |format|
            format.xml  { render :text => "user_exists" }
          end
          return
        end
      end
      respond_to do |format|
        format.xml  { render :xml => @user.to_xml }
      end
    else
      respond_to do |format|
        format.xml  { render :text => "error" }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # PUT /courses/1/delete_user
  # PUT /courses/1/delete_user.xml
  def delete_user
    if current_user.is_admin?
      @course = Course.find(params[:id])
      @course.users.delete(User.find_by_id(params[:user_id]))
      respond_to do |format|
        flash[:notice] = 'Course was successfully updated.'
        format.html { redirect_to(@course) }
        format.xml  { render :text => "success" }
      end
    else
      respond_to do |format|
        flash[:notice] = 'You cannot do this.'
        format.html { redirect_to(@course) }
        format.xml  { render :text => "error" }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  # DELETE /courses/1
  # DELETE /courses/1.xml
  def destroy
    if current_user.is_admin?
      @course = Course.find(params[:id])
      @course.destroy
      respond_to do |format|
        format.html { redirect_to(courses_url) }
        format.xml  { render :xml => "success" }
      end
    else
      respond_to do |format|
        flash[:notice] = 'You cannot do this.'
        format.html { redirect_to(@course) }
        format.xml  { render :text => "error" }
      end
    end
  end

  private
    def prevent_access(e)
      logger.info "CoursesController#prevent_access: #{e}"
      respond_to do |format|
        format.html { redirect_to(courses_url) }
        format.xml  { render :text => "error" }
      end
    end
end