class Permissions < Application
  def show
    @author = Author.find(params[:id])
    raise NotFound unless @author
    @permissions = @author.permissions
    @secondary_title = "Permissions for #{@author.name}"
    render
  end

  def edit
    only_provides :html
    @author = Author.find(params[:id])
    raise NotFound unless @author
    @permissions = Permission.find :all, :order => 'name ASC'
    @secondary_title = "Change permissions for #{@author.name}"
    render
  end

  def update
    @author = Author.find(params[:id])
    raise NotFound unless @author
    @permissions = Permission.find(params[:permissions])
    @author.permissions = @permissions
    redirect url(:permission, @author)
  end
end
