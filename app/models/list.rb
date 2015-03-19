class List < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :permission, inclusion: { in: ['private', 'viewable', 'open'].freeze }

  def can_be_viewed_by?(user)
    (self.user == user) || !self.is_private?
  end

  def editable?(user)
    self.user == user || self.is_open?
  end

  def is_private?
    self.permission == 'private'
  end

  def is_viewable?
    self.permission == 'viewable'
  end

  def is_open?
    self.permission == 'open'
  end
end
