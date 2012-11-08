class KeywordsController < ApplicationController
  # GET /keywords
  # GET /keywords.xml
  def index
    @courses = current_user.courses
    @keywords = Array.new
    @courses.each.entries.each.keywords.each do |k|
      a = @keywords.detect {|x| x == k}
      # avoid duplications
      if a == nil
        @keywords << k
      end
    end
    # sort by keyword value (alphabetic)
    @keywords = @keywords.sort_by {|x| x.value}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @keywords }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  # GET /keywords/list_entries
  # GET /keywords/list_entries.xml
  def list_entries
    @keywords_string = params[:keywords]
    @keywords = @keywords_string.split
    @entries = Array.new
    @keywords.each do |x|
      @keyword = Keyword.find_by_value(x)
      if !@keyword.nil?
        @entries += @keyword.entries.find(:all, :conditions => ["course_id = ?", params[:course_id]])
      end
    end
    @entries.uniq!
    respond_to do |format|
      format.xml { render :xml => @entries}
    end
  end

  private
    def prevent_access(e)
      logger.info "KeywordsController#prevent_access: #{e}"
      respond_to do |format|
        format.html { redirect_to(keywords_url) }
        format.xml  { render :text => "error" }
      end
    end
end