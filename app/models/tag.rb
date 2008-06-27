class Tag < ActiveRecord::Base
  validates_format_of :name, :with => /^\w+$/
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :pages, :order => 'pages.name ASC'
  has_and_belongs_to_many :albums, :order => 'albums.name ASC'
  
  has_many :photo_tags, :dependent => :destroy
  has_many :photos, :through => :photo_tags
  
  def self.popular_tags
    tags = Page.popular_tags
    a_tags = Album.popular_tags
    p_tags = Photo.popular_tags
    
    [ a_tags, p_tags ].each do |ary|
      ary.each do |tag|
        t = tags.detect { |t2| t2.name == tag.name }
        if t
          t.count = t.count.to_i + tag.count.to_i
        else
          tags << tag
        end
      end
    end
    tags.sort { |a,b| a.name <=> b.name }
  end
end