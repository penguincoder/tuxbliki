class Page < ActiveRecord::Base
  validates_format_of :name, :with => /^[\w ]+$/
  validates_uniqueness_of :name
  
  has_many :comments, :order => 'created_at ASC', :dependent => :destroy
  has_and_belongs_to_many :tags, :order => 'tags.name ASC'
  belongs_to :author
  attr_protected :author_id
  has_and_belongs_to_many :pages, :join_table => 'wiki_words', :foreign_key => :source_id, :class_name => 'Page', :association_foreign_key => :destination_id
  has_and_belongs_to_many :pages_that_link_to_me, :join_table => 'wiki_words', :foreign_key => :destination_id, :association_foreign_key => :source_id, :class_name => 'Page'
  
  before_create :set_author_id
  before_save :sanitize_department
  after_save :update_wiki_words
  after_save :destroy_cache
  
  def self.exists?(name)
    !self.find_by_name(name).nil?
  end
  
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
  
  def self.popular_tags(limit = nil)
    query = "SELECT tags.id, tags.name, count(*) AS count FROM pages_tags, tags, pages WHERE tags.id = tag_id AND pages_tags.page_id = pages.id GROUP BY tags.id, tags.name ORDER BY count DESC"
    query << " LIMIT #{limit}" unless limit.nil?
    Tag.find_by_sql(query).sort { |a, b| a.name <=> b.name }
  end
  
  def cache_name
    "RedCloth_#{self.id}"
  end
  
  def self.wiki_word_pattern
    /\[\[([A-Za-z0-9 ]+)\]\]/
  end
  
  protected
  
  def sanitize_department
    self.department.to_s.gsub!(/[^\w']/, '_')
    self.department.to_s.gsub!(/__+/, '_')
    true
  end
  
  def set_author_id
    self.author_id ||= Application.current_author_id
  end
  
  def update_wiki_words
    self.pages.clear
    self.description.gsub(Page.wiki_word_pattern) do |match|
      p = Page.find_by_name($1) rescue nil
      WikiWord.create :source_id => self.id, :destination_id => p.id if p
    end
  end
  
  def destroy_cache
    Cache.delete(self.cache_name)
    self.pages_that_link_to_me.each { |p| Cache.delete(p.cache_name) }
  end
end
