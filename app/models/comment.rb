class Comment < ActiveRecord::Base
  belongs_to :page
  belongs_to :author
  
  def name
    if self.author
      self.author.name
    else
      self.user
    end
  end
end