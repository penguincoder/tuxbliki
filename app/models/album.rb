class Album < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[\w ]+$/
  has_and_belongs_to_many :tags, :order => 'tags.name ASC'
  has_many :photos
  after_create :save_tags
  
  def tag_names
    self.tags.collect { |t| t.name }.join(' ')
  end
  
  def tag_names=(newtags)
    tag_name_ary = newtags.split if newtags.is_a?(String)
    tag_name_ary ||= newtags
    new_tags = []
    tag_name_ary.each do |tname|
      t = Tag.find_by_name tname
      t ||= Tag.create :name => tname
      new_tags << t
    end
    self.tags = new_tags
  end
  
  def album_thumbnail
    self.photos.first
  end
  
  def self.for_select
    self.find(:all, :select => 'name', :order => 'name ASC').collect do |a|
      a.name
    end
  end
  
  def self.popular_tags(limit = nil)
    query = "SELECT tags.id, tags.name, count(*) AS count FROM albums_tags, tags, albums WHERE tags.id = tag_id AND albums_tags.album_id = albums.id GROUP BY tags.id, tags.name ORDER BY tags.name ASC"
    query << " LIMIT #{limit}" unless limit.nil?
    Tag.find_by_sql(query)
  end
  
  protected
  
  def save_tags
    self.tags.each { |x| x.save }
  end
end