class Node < Application
  def index
    redirect('/')
  end
  
  def show
    page = Page.find_by_nid(params[:id])
    raise NotFound unless page or params[:id] == 'feed'
    purl = url(:page, :id => page.name.gsub(/ /, '_')) rescue ''
    purl = url(:controller => :feeds, :action => :rss, :format => :xml) if params[:id] == 'feed'
    Merb.logger.info("Permenant Redirect Drupal Node to #{purl}")
    self.status = 301
    headers['Location'] = purl
    return "<html><body>You are being <a href=\"#{purl}\">redirected</a>.</body></html>"
  end
  
  def chora
    if params[:program] and params[:program] =~ /PenguinCoder|tuxwiki/i
      raise NotFound
    end
    safe_program = params[:program].gsub(/\W/, '').downcase
    gurl = "http://github.com/penguincoder/#{safe_program}"
    Merb.logger.info("Permenant Chora redirect for #{safe_program}")
    self.status = 301
    headers['Location'] = gurl
    return "<html><body>You are being <a href=\"#{gurl}\">redirected</a>.</body></html>"
  end
end
