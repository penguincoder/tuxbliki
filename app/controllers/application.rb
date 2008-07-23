class Application < Merb::Controller
  cattr_accessor :current_author_id
  before :set_current_author_id
  
  def logged_in?
    !session[:author_id].nil?
  end
  
  def set_current_author_id
    self.current_author_id = session[:author_id]
  end
  
  def get_photo_version(width, height)
    key = "photo_#{@photo.id}_#{width}_#{height}"
    img = Cache.get(key)
    
    File.open("#{@photo.base_directory}/#{@photo.filename}", "r") do |f|
      img = Magick::Image.from_blob(f.read).first.resize_to_fit(width, height)
      Cache.put(key, img)
    end if img.nil?
    
    img
  end
  
  def tuxconfig
    Merb::Plugins.config[:tuxbliki]
  end
end