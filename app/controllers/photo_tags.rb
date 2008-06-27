class PhotoTags < Application
  def index
    redirect url(:tags)
  end
  
  def show
    @photo = Photo.find(params[:id])
    @editable = !params[:editable].nil?
    partial 'photo_tags'
  end
  
  def create
    @photo = Photo.find(params[:photo_tag][:photo_id]) rescue nil
    raise NotFound unless @photo
    
    params[:tags].split.each do |tag_name|
      t = Tag.find_by_name(tag_name) rescue nil
      t ||= Tag.create :name => tag_name
      pt = PhotoTag.new(params[:photo_tag])
      pt.tag = t
      pt.save
    end
    
    @editable = true
    partial 'photo_tags'
  end
  
  def destroy
    @photo_tag = PhotoTag.find(params[:id])
    raise NotFound unless @photo_tag
    @photo = @photo_tag.photo
    raise NotFound unless @photo
    if @photo_tag.destroy
      @editable = true
      partial 'photo_tags'
    else
      render :text => @photo_tag.errors.collect { |e| e.to_s }.join(', '),
        :status => 500
    end
  end
end
