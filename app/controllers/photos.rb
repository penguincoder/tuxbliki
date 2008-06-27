class Photos < Application
  def index
    redirect url(:albums)
  end

  def show
    @photo = Photo.find_by_id(params[:id])
    raise NotFound unless @photo
    @secondary_title = h(@photo.filename)
    
    img = get_photo_version(600, 600)
    @width = img.columns
    @height = img.rows
    
    render
  end

  def new
    only_provides :html
    @photo = Photo.new(params[:photo])
    render
  end

  def create
    @photo = Photo.new(params[:photo])
    if params[:photo][:album_id].to_i == 0
      album = (Album.find_by_name(params[:photo][:album_id]) rescue nil)
      raise NotFound unless album
      @photo.album = album
    end
    if @photo.save
      redirect url(:photo, @photo)
    else
      render :new
    end
  end

  def edit
    only_provides :html
    @photo = Photo.find_by_id(params[:id])
    raise NotFound unless @photo
    render
  end

  def update
    @photo = Photo.find_by_id(params[:id])
    raise NotFound unless @photo
    @photo.attributes = params[:photo]
    if params[:photo][:album_id].to_i == 0
      album = (Album.find_by_name(params[:photo][:album_id]) rescue nil)
      raise NotFound unless album
      @photo.album = album
    end
    if @photo.save
      redirect url(:photo, @photo)
    else
      raise BadRequest
    end
  end

  def delete
    @photo = Photo.find_by_id(params[:id])
    raise NotFound unless @photo
    if @photo.destroy
      redirect url(:photos)
    else
      raise BadRequest
    end
  end

  def thumbnail
    only_provides :html
    @photo = Photo.find(params[:id])
    raise NotFound unless @photo
    send_data get_photo_version(150, 150).to_blob,
      :filename => @photo.filename, :disposition => 'inline',
      :type => @photo.content_type
  end
  
  def screen
    only_provides :html
    @photo = Photo.find(params[:id])
    raise NotFound unless @photo
    send_data get_photo_version(600, 600).to_blob,
      :filename => @photo.filename, :disposition => 'inline',
      :type => @photo.content_type
  end
end
