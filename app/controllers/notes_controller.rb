class NotesController < ApplicationController
  # GET /notes
  # GET /notes.xml
  def index
    @notes = current_user.notes

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.xml
  def show
    @note = current_user.notes.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @note }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  # GET /notes/new
  # GET /notes/new.xml
  def new
    @note = Note.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = current_user.notes.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  # POST /notes
  # POST /notes.xml
  def create
    @note = current_user.notes.build(params[:note])
    respond_to do |format|
      if @note.save
        format.html do
          flash[:notice] = 'Note was successfully created.'
          redirect_to(@note)
        end
        format.xml  { render :xml => @note.to_xml }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors,
          :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = current_user.notes.find(params[:id])
    respond_to do |format|
      if @note.update_attributes(params[:note])
        flash[:notice] = 'Note was successfully updated.'
        format.html { redirect_to(@note) }
        format.xml  { render :text => "success" }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors,
          :status => :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @note = current_user.notes.find(params[:id])
    @note.destroy

    respond_to do |format|
      format.html { redirect_to(notes_url) }
      format.xml  { render :text => "success" }
    end
  rescue ActiveRecord::RecordNotFound => e
    prevent_access(e)
  end

  private
    def prevent_access(e)
      logger.info "NotesController#prevent_access: #{e}"
      respond_to do |format|
        format.html { redirect_to(notes_url) }
        format.xml  { render :text => "error" }
      end
    end
end