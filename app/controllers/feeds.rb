class Feeds < Application
  only_provides :xml
  def rss
    @items = []
    [ Page, Comment ].each do |kls|
      @items.concat kls.find(:all, :limit => 25, :order => 'created_at DESC')
    end
    @items.sort! do |a, b|
      b.created_at <=> a.created_at
    end
    render :format => :xml
  end
end
