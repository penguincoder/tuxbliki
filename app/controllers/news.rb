class News < Application
  def index
    ncount = Page.count :conditions => [ 'published = ?', true ]
    @page = params[:page].to_i
    per_page = 5
    @page_count = (ncount.to_f / per_page.to_f).ceil.to_i
    @page = 0 if @page >= @page_count
    @url_key = :news
    @page_title = tuxconfig[:news_heading]
    @news = Page.find :all, :limit => per_page, :offset => (@page * per_page), :conditions => [ 'published = ?', true ], :order => 'created_at DESC'
    oldest_date = Page.find(:first, :select => 'created_at', :order => 'created_at ASC').created_at rescue nil
    @secondary_title = tuxconfig[:motto]
    if tuxconfig[:motto_with_date] and oldest_date
      @secondary_title += " #{time_lost_in_words(Time.now, oldest_date)}"
    end
    @tags = Page.popular_tags(30)
    render
  end
end
