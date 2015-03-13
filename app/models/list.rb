class List < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :permission, inclusion: { in: ['private', 'viewable', 'open'].freeze }

  def can_be_viewed_by?(user)
    self.user == user || !self.private
  end

  def private
    self.permission == 'private'
  end

  def viewable
    self.permission == 'viewable'
  end

  def open
    self.permission == 'open'
  end
end
