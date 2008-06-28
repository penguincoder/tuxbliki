class News < Application
  def index
    ncount = Page.count :conditions => [ 'published = ?', true ]
    @page = params[:page].to_i
    per_page = 5
    @page_count = (ncount.to_f / per_page.to_f).ceil.to_i
    @page = 0 if @page >= @page_count
    @url_key = :news
    @page_title = 'Blogging!'
    @news = Page.find :all, :limit => per_page, :offset => (@page * per_page), :conditions => [ 'published = ?', true ], :order => 'created_at DESC'
    @oldest_date = Page.find(:first, :order => 'created_at ASC').created_at rescue nil
    @tags = Page.popular_tags(30)
    render
  end
end
