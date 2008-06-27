class Comments < Application
  def new
    only_provides :html
    @page = Page.find_by_name(params[:page_id].gsub(/_/, ' '))
    raise NotFound unless @page
    @comment = Comment.new
    render
  end

  def create
    @page = Page.find_by_name(params[:page_id].gsub(/_/, ' '))
    raise NotFound unless @page
    @comment = Comment.new(params[:comment])
    @comment.page_id = @page.id
    if @comment.save
      flash[:notice] = 'Great success!'
      redirect url(:page, :id => params[:page_id])
    else
      render :new
    end
  end

  def delete
    @comment = Comment.find(params[:id])
    raise NotFound unless @comment
    @page = @comment.page
    if @comment.destroy!
      flash[:notice] = 'Comment was destroyed.'
      redirect url(:page, :id => @page.name.gsub(/ /, '_'))
    else
      raise BadRequest
    end
  end
end
