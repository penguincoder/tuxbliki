class Comment < ActiveRecord::Base
  belongs_to :page
  belongs_to :author
  validate :safe_url
  
  def name
    if self.author
      self.author.name
    else
      self.user
    end
  end
  
  private
  
  def safe_url
    return true if self.url.to_s.empty?
    if self.url =~ /^http:\/\// and self.url !~ /[^a-zA-Z0-9\._:\-\/]/
      true
    else
      self.errors.add(:url, "is not a permissible address")
      false
    end
  end
end