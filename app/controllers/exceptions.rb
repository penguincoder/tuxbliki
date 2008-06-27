class Exceptions < Application
  # handle NotFound exceptions (404)
  def not_found
    @page_title = 'Error 404'
    @secondary_title = 'Document Not Found'
    render :format => :html
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    @page_title = 'Error 500'
    @secondary_title = 'Application Exception'
    render :format => :html
  end
end