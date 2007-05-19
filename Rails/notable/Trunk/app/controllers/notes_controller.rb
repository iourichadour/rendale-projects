class NotesController < ApplicationController
before_filter :login_required  

  #list
  def index 
    @notes = current_user.notes.find(:all,:order => "date desc, id desc")
  end
  
  def get_descr
    @note = current_user.notes.find(params[:id])
    if @note.description.nil?
      render :nothing => true    
    else
      render :text => @note.description, :layout=>false    
    end
  end
    
  #create
  def new
    @note = current_user.notes.create(:date=>Time.now)
    render :update do |page|
      page.insert_html(:top, 'notes_block', :partial => 'note_listing', :object => @note)
      page.visual_effect(:appear, "note#{@note.id}", :duration=>0.15)
    end
  end

  #update
  def update_descr
    @note = current_user.notes.find(params[:id])
    @note.description=params[:value]
    @note.save   
    render :text=> RedCloth.new(@note.description).to_html, :layout=>false
  end
    
  def update_position
  	@note = current_user.notes.find(params[:id])
  	if !@note.nil?
  	 @note.x = params[:x]
     @note.y = params[:y]
     @note.z = params[:z]
     @note.save
  	end
  	  render :nothing => true
  end
  
  #delete
  def destroy
    begin
      @notes = current_user.notes.find(:all)
      @note = current_user.notes.find(params[:id])
      if !@note.nil?
        @note.destroy
        taggings = @note.taggings.length
      else
        taggings = 0
      end
    rescue
    end
    render :update do |page|
      if taggings > 0 
        page.replace_html('cloud', generate_tag_cloud())
        page.visual_effect(:pulsate, 'cloud', :duration=>1)
      end    
      page.visual_effect(:fade, "note#{params[:id]}", :duration=>0.15)
    end

  end
  
  
  #Tags
  #create  
  def add_tag 
   @notes = current_user.notes
   @note = Note.find(params[:id]) 
   @note.taggings.each{|n| n.destroy}
   if params[:value].blank? || params[:value] == 'add tags to this note'
     render :text => 'add tags to this note'
   else     
     tagArray = params[:value].split(" ")
     tagArray.each do | tag |
       if @note.tags.find_by_name(tag) != nil
       else
         @note.tag_with(tag)        
       end
     end     
     render :update do |page|
       page.replace_html('tags' + params[:id].to_s, @note.tags.collect{|tag| tag.name}.join(", "))
       page.replace_html('cloud', generate_tag_cloud())
       page.visual_effect(:pulsate, 'cloud', :duration=>1)
     end
   end
  
  end

  #find
  def search_by_tag
    @notes = if tag_name = params[:tag_search] 
    begin
    Tag.find_by_name(tag_name).tagged 
    rescue
      flash[:notice] = 'No notes found with that tag'
      redirect_to :action => 'index'
    end
    else 
      flash[:notice] = 'No notes found with that tag'
      redirect_to :action => 'index'
    end 
  end  

  #Files
  #add
  def add_file
 	  @note = current_user.notes.find(params[:id])
    File.open(RAILS_ROOT + "/tmp/#{current_user.id.to_s}_#{@note.id.to_s}", "wb"){ |f| f.write("done")}
	  @note_file = @note.note_files.build
    if @note_file.add_file(params[:note_file][:file])
      @note_file.save
#      render :partial => 'uploading_progress', :object => @note
       render :partial => 'file_upload_control_done', :object => @note
    else
      @error_message = @note_file.error_message
      render :partial => 'file_upload_control_error', :object => @note
    end
  end 
  
  #delete
  def delete_file
    @note = current_user.notes.find(params[:id])
    @note_file = @note.note_files.find(params[:note_file_id])
    @note_file.destroy
    redirect_to :action => 'home'
  end
  
  #find
  def get_file
	@note_file = current_user.notes.find(params[:id]).note_files.find(params[:file_id])	  
  	if params[:type].nil? 
	    send_file(RAILS_ROOT + "/files/" + @note_file.systempath + @note_file.filename, :disposition => 'attachment', :type => @note_file.filetype)
	  else
	    send_file(RAILS_ROOT + "/files/" + @note_file.systempath + "thumb_" + @note_file.filename, :disposition => 'attachment', :type=>@note_file.filetype)
	  end
  end

  #methods for dynamic control
  def file_upload_control   
    @note = current_user.notes.find(params[:id]) 
    render :partial => 'file_upload_control', :object => @note
  end
  
  def file_upload_control_done   
    @note = current_user.notes.find(params[:id]) 
    render :partial => 'file_upload_control_done', :object => @note
  end

  def file_upload_control_error   
    @note = current_user.notes.find(params[:id]) 
    render :partial => 'file_upload_control_error', :object => @note
  end


  def check_for_file    
    @note = current_user.notes.find(params[:id])
    if File.exists?(RAILS_ROOT + "tmp/#{current_user.id.to_s}_#{@note.id}")
      File.delete(RAILS_ROOT + "/tmp/#{current_user.id.to_s}_#{@note.id}")
      render :text => "window.location='/notes/file_upload_control_done/#{@note.id}';",
                      :layout => false
    else
      render :nothing => true
    end
  end  
end
