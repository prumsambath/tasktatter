class List < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :permission, inclusion: { in: ['private', 'viewable', 'open'].freeze }

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
