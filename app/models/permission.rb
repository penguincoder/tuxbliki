class Permission < ActiveRecord::Base
  has_and_belongs_to_many :authors
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def self.author_has_permission_to?(name, author = nil)
    p = self.find_by_name(name.to_s)
    p ||= self.create :name => name.to_s # auto-create permission if necessary
    p.authors.include?(author)
  end
end