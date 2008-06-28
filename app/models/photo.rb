class Photo < ActiveRecord::Base
  attr_accessor :file
  
  validates_presence_of :author_id, :album_id
  
  belongs_to :album
  belongs_to :author
  has_many :photo_tags, :dependent => :destroy
  has_many :tags, :through => :photo_tags
  
  before_validation_on_create :set_author_id
  before_create :validate_image_sanity
  after_create :create_directories
  before_destroy :destroy_directories
  
  attr_protected :author_id
  
  ##
  # Determines the base directory for all files in this model.
  #
  def base_directory
    "#{Merb.root}/public/photos/#{id}"
  end
  
  ##
  # Checks to see if the file is found on the filesystem.
  #
  def exist?
    File.exist?(self.pathname)
  end
  
  ##
  # Returns the full path to the file on the filesystem.
  #
  def pathname
    "#{self.base_directory}/#{self.filename}"
  end
  
  def self.popular_tags(limit = nil)
    query = "SELECT tags.id, tags.name, count(*) AS count FROM photo_tags, tags, photos WHERE tags.id = tag_id AND photo_tags.photo_id = photos.id GROUP BY tags.id, tags.name ORDER BY tags.name ASC"
    query << " LIMIT #{limit}" unless limit.nil?
    Tag.find_by_sql(query)
  end
  
  protected
  
  ##
  # Sets the Author marker for ownership on creation.
  #
  def set_author_id
    self.author_id ||= Application.current_author_id
  end
  
  ##
  # Checks to make sure that the file exists and is an image.
  #
  def validate_image_sanity
    if self.file[:tempfile].nil?
      self.errors.add(:file, 'File is not a file')
    end
    if self.file[:content_type] !~ /image\/\w+/
      self.errors.add(:file, 'File is not a supported type')
    end
    if self.file[:size] > 3 * 1048576
      self.errors.add(:file, 'File is too big (3MB max)')
    end
    return false unless self.errors.empty?
    
    begin
      @fstr = self.file[:tempfile].read
      iary = Magick::Image.from_blob(@fstr)
      self.filename = File.basename(self.file[:filename]).gsub(/[^\w._-]/, '')
      if iary.first.to_s =~ / (\d+)x(\d+) /
        self.width = $1
        self.height = $2
      end
    rescue
      $stderr.puts("Caught an exception saving an image:")
      $stderr.puts("* #{$!}")
      self.errors.add(:file, 'File could not be read as an image')
      return false
    end
    
    self.content_type = self.file[:content_type]
    true
  end
  
  ##
  # Makes the directories and writes the file to disk.
  #
  def create_directories
    File.umask(0022)
    Dir.mkdir(base_directory) unless File.exist?(base_directory)
    File.open("#{base_directory}/#{self.filename}", "w") do |f|
      f.puts(@fstr)
    end
    File.chmod(0644, "#{base_directory}/#{self.filename}")
  end
  
  ##
  # Removes the directories and files associated with this model on destroy.
  #
  def destroy_directories
    return unless File.exists?(base_directory)
    Dir.foreach(base_directory) do |file|
      next if file =~ /^\.\.?$/
      File.delete(base_directory + '/' + file)
    end
    Dir.delete(base_directory)
  end
end