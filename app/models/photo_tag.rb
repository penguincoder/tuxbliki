class PhotoTag < ActiveRecord::Base
  belongs_to :photo
  belongs_to :tag
  validates_presence_of :photo_id, :tag_id, :x, :y
end