class Albums < Application
  def index
    @albums = Album.find(:all)
    @tags = Album.popular_tags(30)
    display @albums
  end

  def show
    @album = Album.find_by_name(params[:id].gsub(/_/, ' '))
    raise NotFound unless @album
    display @album
  end

  def new
    only_provides :html
    @secondary_title = 'Create an album'
    @album = Album.new(params[:album])
    render
  end

  def create
    @album = Album.new(params[:album])
    if @album.save
      redirect url(:album, @album.name.gsub(/ /, '_'))
    else
      @secondary_title = 'Create an album'
      render :new
    end
  end

  def edit
    only_provides :html
    @album = Album.find_by_name(params[:id].gsub(/_/, ' '))
    @secondary_title = 'Update an album'
    raise NotFound unless @album
    render
  end

  def update
    @album = Album.find_by_name(params[:id].gsub(/_/, ' '))
    raise NotFound unless @album
    @secondary_title = 'Update an album'
    if @album.update_attributes(params[:album])
      redirect url(:album, @album.name.gsub(/ /, '_'))
    else
      raise BadRequest
    end
  end

  def delete
    @album = Album.find_by_name(params[:id].gsub(/_/, ' '))
    raise NotFound unless @album
    if @album.destroy
      redirect url(:albums)
    else
      raise BadRequest
    end
  end

end
