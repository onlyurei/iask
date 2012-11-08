class QueriesController < ApplicationController
  # GET /queries
  # GET /queries.xml
  def index
    if current_user.is_teacher?
      @queries = Query.find(:all, :conditions => ["teacher_id = ?", current_user.id],
                            :order => "id DESC")
    else
      @queries = Query.find(:all, :conditions => ["student_id = ?", current_user.id],
                            :order => "id DESC")
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @queries }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # GET /queries/unsolved
  # GET /queries/unsolved.xml
  def unsolved
    if current_user.is_teacher?
      @queries = Query.find(:all, :conditions => ["teacher_id = ? and solved = '0'", current_user.id],
                            :order => "id DESC")
    else
      @queries = Query.find(:all, :conditions => ["student_id = ? and solved = '0'", current_user.id],
                            :order => "id DESC")
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @queries }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # GET /queries/solved
  # GET /queries/solved.xml
  def solved
    if current_user.is_teacher?
      @queries = Query.find(:all, :conditions => ["teacher_id = ? and solved = '1'", current_user.id],
                            :order => "id DESC")
    else
      @queries = Query.find(:all, :conditions => ["student_id = ? and solved = '1'", current_user.id],
                            :order => "id DESC")
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @queries }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # GET /queries/1
  # GET /queries/1.xml
  def show
    @courses = current_user.courses
    @courses = @courses.sort_by {|x| x.name}
    @queries = Array.new
    @courses.each do |c|
      @queries += c.queries
    end
    @query = @queries.find(params[:id])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @query }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  # PUT /queries/1
  # PUT /queries/1.xml
  def update
    @query =Query.find(params[:id])
    if current_user.is_teacher?
      if @query.teacher_id == current_user.id
        @query.update_attributes(params[:query])
      else
        prevent_access
      end
    else
      if @query.student_id == current_user.id
        @query.update_attributes(params[:query])
        if @query.solved?
          @teacher = User.find_by_id(@query.teacher_id)
          @sum = @teacher.entries_sum
          @sum += 1
          @teacher.entries_sum = @sum
          @teacher.save!
        end
      else
        prevent_access
      end
    end
    respond_to do |format|
      flash[:notice] = 'Query was successfully updated.'
      format.html { redirect_to(@query) }
      format.xml  { render :text => "success" }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  # DELETE /queries/1
  # DELETE /queries/1.xml
  def destroy
    @query = Query.find(params[:id])
    if current_user.is_teacher?
      if @query.teacher_id == current_user.id
        if @query.solved?
           current_user.entries_sum -= 1
           current_user.save!
        end
        @query.destroy
      else
        prevent_access
      end
    else
      prevent_access
    end
    respond_to do |format|
      format.html { redirect_to(queries_url) }
      format.xml  { render :text => "success" }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  
  private
  def prevent_access(e)
    logger.info "QueriesController#prevent_access: #{e}"
    respond_to do |format|
      format.html { redirect_to(keywords_url) }
      format.xml  { render :text => "error" }
    end
  end
end
