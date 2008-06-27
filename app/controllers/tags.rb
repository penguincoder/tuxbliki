class Tags < Application
  def index
    @tags = Tag.popular_tags
    @secondary_title = 'Tag Cloud'
    display @tags
  end

  def show
    @tag = Tag.find_by_name(params[:id])
    raise NotFound unless @tag
    @pages = @tag.pages
    @albums = @tag.albums
    @secondary_title = "Content tagged with #{@tag.name}"
    display @tag
  end

  def new
    redirect '/'
  end

  def edit
    only_provides :html
    @tag = Tag.find_by_name(params[:id])
    raise NotFound unless @tag
    render
  end

  def create
    redirect '/'
  end

  def update
    @tag = Tag.find_by_name(params[:id])
    raise NotFound unless @tag
    if @tag.update_attributes(params[:tag])
      flash[:notice] = 'The tag was updated.'
      redirect url(:tag, :id => @tag.name)
    else
      raise BadRequest
    end
  end

  def delete
    @tag = Tag.find_by_name(params[:id])
    raise NotFound unless @tag
    if @tag.destroy
      flash[:notice] = "The tag #{@tag.name} was destroyed."
      redirect url(:tag)
    else
      raise BadRequest
    end
  end

  def auto_complete
    @phrase = params[:id].split.last
    @tags = Tag.find :all, :limit => 15, :order => 'name ASC',
      :conditions => [ 'name LIKE ?', "%#{@phrase}%" ]
    @tags.<< Tag.new(:name => @phrase) unless @tags.detect { |t| t.name == @phrase }
    partial 'tags/tag_autocomplete_results', :read_only => true
  end
end
