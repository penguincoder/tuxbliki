class Invitation < ActiveRecord::Base
  before_create :set_invitation_code
  validates_presence_of :recipient
  validates_format_of :recipient, :with => /^.+\@.+\.\w{2,3}$/,
    :message => 'appears to be a fake'
  attr_accessor :recipient
  
  protected
  
  def set_invitation_code
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    check = nil
    begin
      check = ''
      1.upto(32) { |k| check << chars[rand(chars.size - 1)] }
    end while Invitation.find_by_code(check)
    self.code = check
  end
end