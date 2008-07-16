class Exceptions < Application
  include MerbExceptions::ControllerExtensions
  
  # handle NotFound exceptions (404)
  def not_found
    @page_title = 'Error 404'
    @secondary_title = 'Document Not Found'
    render
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    @page_title = 'Error 500'
    @secondary_title = 'Application Exception'
    render_and_notify :format => :html
  end
end
