class Photos < Application
  def index
    redirect url(:albums)
  end

  def show
    @photo = Photo.find_by_id(params[:id])
    raise NotFound unless @photo
    @secondary_title = h(@photo.filename)
    
    img = get_photo_version(600, 600) rescue nil
    @width = img.columns rescue 150
    @height = img.rows rescue 150
    
    @album_photos = @photo.album.photos.find :all, :order => 'filename ASC'
    @max_index = @album_photos.size - 1
    @current_index = @album_photos.index(@photo)
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
      if @photo.album
        redirect url(:album, @photo.album)
      else
        redirect url(:photos)
      end
    else
      raise BadRequest
    end
  end

  def send_rmagicked_image
    only_provides :html
    @photo = Photo.find(params[:id])
    raise NotFound unless @photo
    if @photo.exist?
      w = case params[:action]
        when 'screen'
          600
        else
          150
      end
      send_data get_photo_version(w, w).to_blob,
        :filename => @photo.filename, :disposition => 'inline',
        :type => @photo.content_type
    else
      send_file Merb.root + '/public/images/image-missing.png', :disposition => 'inline'
    end
  end
  alias_method :thumbnail, :send_rmagicked_image
  alias_method :screen, :send_rmagicked_image
  
  def set_album_thumbnail
    only_provides :html
    @photo = Photo.find(params[:id])
    raise NotFound unless @photo
    @album = @photo.album
    raise NotFound unless @album
    if @album.update_attribute(:album_thumbnail_id, @photo.id)
      flash[:notice] = 'Very nice!'
    else
      flash[:error] = 'Could not update the album:<br />'
      @album.errors.each_full { |msg| flash[:error] += "#{msg}<br />" }
    end
    redirect url(:photo, @photo)
  end
end
