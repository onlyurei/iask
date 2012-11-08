class EntriesController < ApplicationController
  # GET /entries
  # GET /entries.xml
  def index
    @courses = current_user.courses
    @courses = @courses.sort_by {|x| x.name}
    @entries = Array.new
    @courses.each do |c|
      @entries += c.entries
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entries }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # GET /entries/1
  # GET /entries/1.xml
  def show
    @entry = @entries.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entry }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # GET /entries/1/list_keywords
  # GET /entries/1/list_keywords.xml
  def list_keywords
    @entry = Entry.find(params[:id])
    @keywords = @entry.keywords
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @keywords }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # GET /entries/1/list_relevances
  # GET /entries/1/list_relevances.xml
  def list_relevances
    @entry = Entry.find(params[:id])
    @relevances = @entry.relevances
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @relevances }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # POST /entries/1/create_keyword
  # POST /entries/1/create_keyword.xml
  def create_keyword
    @entry = current_user.entries.find(params[:id])
    @keyword = Keyword.find_by_value(params[:keyword_value])
    if @keyword.nil?
      @keyword = Keyword.create(params[:keyword])
    end
    @relevance = Relevance.new(params[:relevance])
    @relevance.entry = @entry
    @relevance.keyword = @keyword
    @relevance.save
    respond_to do |format|
      format.html do
        flash[:notice] = 'Keyword was successfully created.'
        redirect_to(@keyword)
      end
      format.xml  { render :text => "success" }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  # PUT /entries/1/update_keyword
  # PUT /entries/1/update_keyword.xml
  def update_keyword
    @entry = current_user.entries.find(params[:id])
    @keyword = Keyword.find_by_id(params[:keyword_id])
    @relevance = @keyword.relevances.find_by_entry_id_and_keyword_id(params[:id], params[:keyword_id])
    respond_to do |format|
      if @relevance.update_attributes(params[:relevance])
          format.html { redirect_to(@entry) }
          format.xml { render :text => "success"}
      else
        format.html { render :action => "edit" }
        format.xml { render :text => "save_error" }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  # PUT /entries/1
  # PUT /entries/1.xml
  def update
    @entry = current_user.entries.find(params[:id])
    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        flash[:notice] = 'Entry was successfully updated.'
        format.html { redirect_to(@entry) }
        format.xml  { render :text => "success" }
      else
        format.html { render :action => "edit" }
        format.xml  { render :text => "save_error" }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  # DELETE /entries/1
  # DELETE /entries/1.xml
  def destroy
    @entry = current_user.entries.find(params[:id])
    @entry.destroy
    current_user.entries_sum -= 1
    current_user.save!
    respond_to do |format|
      format.html { redirect_to(entries_url) }
      format.xml  { render :text => "success" }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  
  # DELETE /entries/1/destroy_relevance
  # DELETE /entries/1/destroy_relevance.xml
  def destroy_relevance
    @entry = current_user.entries.find(params[:id])
    @relevance = Relevance.find_by_entry_id_and_keyword_id(params[:id], params[:keyword_id])
    @relevance.destroy
    respond_to do |format|
      format.html { redirect_to(keywords_url) }
      format.xml  { render :text => "success" }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end
  
  
  private
  def prevent_access(e)
    logger.info "EntriesController#prevent_access: #{e}"
    respond_to do |format|
      format.html { redirect_to(keywords_url) }
      format.xml  { render :text => "error" }
    end
  end
end
