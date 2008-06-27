class Sessions < Application
  def new
    only_provides :html
    render
  end

  def create
    author = Author.authenticate(params[:username], params[:password])
    if author
      session[:author_id] = author.id
      flash[:notice] = "Welcome back #{author.name}"
      redirect '/'
    else
      flash[:error] = 'Login failed.'
      render :new
    end
  end

  def update
    redirect '/'
  end

  def delete
    session[:author_id] = nil
    flash[:notice] = "You have logged out"
    redirect '/'
  end
end
