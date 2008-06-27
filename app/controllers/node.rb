class Node < Application
  def index
    redirect('/')
  end
  
  def show
    page = Page.find_by_nid(params[:id])
    raise NotFound unless page
    purl = url(:page, :id => page.name.gsub(/ /, '_'))
    Merb.logger.info("Permenant Redirect Drupal Node to #{purl}")
    self.status = 301
    headers['Location'] = purl
    return "<html><body>You are being <a href=\"#{purl}\">redirected</a>.</body></html>"
  end
end