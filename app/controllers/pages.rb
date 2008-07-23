class Pages < Application
  def index
    @pages = Page.find :all, :order => 'name ASC', :conditions => [ 'published = ?', false ]
    @secondary_title = 'Wiki Pages. En Masse.'
    @tags = Page.popular_tags(30)
    display @pages
  end

  def show
    @page = Page.find_by_name(params[:id].gsub(/_/, ' '))
    if @page.nil?
      redirect url(:new_page, :new_name => params[:id])
    else
      @comments = @page.comments
      @secondary_title = @page.name
      display @page
    end
  end

  def new
    @page_title = 'Make a new page'
    only_provides :html
    @page = Page.new :published => true
    if params[:new_name]
      flash.now[:error] = 'That page does not exist, but you can create it.'
      @page.name = params[:new_name].gsub(/_/, ' ')
    end
    render
  end

  def edit
    @page_title = 'Update page'
    only_provides :html
    @page = Page.find_by_name(params[:id].gsub(/_/, ' '))
    raise NotFound unless @page
    render
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      flash[:notice] = "Great success!"
      redirect url(:page, :id => @page.name.gsub(/ /, '_'))
    else
      render :new
    end
  end

  def update
    @page = Page.find_by_name(params[:id].gsub(/_/, ' '))
    raise NotFound unless @page
    if @page.update_attributes(params[:page])
      flash[:notice] = "Great success!"
      redirect url(:page, :id => @page.name.gsub(/ /, '_'))
    else
      render :edit
    end
  end

  def delete
    @page = Page.find_by_name(params[:id].gsub(/_/, ' '))
    raise NotFound unless @page
    if @page.destroy
      flash[:notice] = "The page was successfully destroyed."
      redirect url(:page)
    else
      raise BadRequest
    end
  end

end
