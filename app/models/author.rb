require 'digest/sha1'

class Author < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_format_of :name, :with => /^\w+$/
  
  attr_accessor :password, :password_confirmation
  attr_protected :encrypted_password, :salt
  
  has_and_belongs_to_many :permissions
  has_many :pages
  
  before_save :encrypt_password
  
  def self.authenticate(username, password)
    user = self.find_by_name(username)
    return nil if user.nil?
    user.matches_password?(password) ? user : nil
  end
  
  def matches_password?(cleartext_password)
    self.encrypted_password == Digest::SHA1.hexdigest("---#{cleartext_password}---#{self.salt}---")
  end
  
  protected
  
  def encrypt_password
    skip = false
    if self.password.to_s.empty? or self.password_confirmation.to_s.empty?
      if self.encrypted_password.to_s.empty?
        self.errors.add(:password, 'cannot be blank')
      else
        skip = true
      end
    elsif self.password != self.password_confirmation
      self.errors.add(:passwords, 'do not match')
    end
    return false unless self.errors.empty?
    return if skip
    self.salt = Digest::SHA1.hexdigest("---#{Time.now}---#{rand.to_s}---")
    self.encrypted_password = Digest::SHA1.hexdigest("---#{self.password}---#{self.salt}---")
    self.encrypted_password
  end
end