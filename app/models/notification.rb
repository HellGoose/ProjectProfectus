class Notification < ActiveRecord::Base
  #Restrictions:
  validates :points, :notification, presence: true

  #Relations (Used like: ClassName.relation):
  belongs_to :user

  #Callbacks
  after_initialize :init

private
  #Set default values
  def init
    self.points ||= 0 if self.has_attribute? :points
    self.notification ||= "" if self.has_attribute? :notification
    self.icon ||= "" if self.has_attribute? :icon
    self.link ||= "" if self.has_attribute? :link
    self.seen ||= false if self.has_attribute? :seen
    self.popup ||= false if self.has_attribute? :popup
  end
end
