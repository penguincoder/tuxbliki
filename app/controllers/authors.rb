class Authors < Application
  def index
    @authors = Author.find :all, :order => 'name ASC'
    @secondary_title = 'Authors'
    display @authors
  end

  def show
    @author = Author.find_by_name(params[:id])
    raise NotFound unless @author
    @secondary_title = "#{@author.name}'s page"
    display @author
  end

  def new
    only_provides :html
    @author = Author.new
    @secondary_title = "It's better than herpes!"
    render
  end

  def edit
    only_provides :html
    @author = Author.find_by_name(params[:id])
    raise NotFound unless @author
    render
  end

  def create
    @author = Author.new(params[:author])
    @invitation = Invitation.find_by_code params[:invitation_code]
    if @invitation.nil?
      flash[:notice] = 'You are not invited, you will need to try again later.'
      render :new
    elsif @author.save
      flash[:notice] = 'Great success!'
      @invitation.destroy
      redirect url(:author, :id => @author.name)
    else
      render :new
    end
  end

  def update
    @author = Author.find_by_name(params[:id])
    raise NotFound unless @author
    if @author.update_attributes(params[:author])
      flash[:notice] = 'Great success!'
      redirect url(:author, :id => @author.name)
    else
      raise BadRequest
    end
  end

  def delete
    @author = Author.find_by_name(params[:id])
    raise NotFound unless @author
    if @author.destroy!
      flash[:notice] = 'The author was destroyed.'
      if @author.id == session[:author_id]
        redirect url(:delete_session, :id => session[:author_id])
      else
        redirect url(:author)
      end
    else
      raise BadRequest
    end
  end
end
