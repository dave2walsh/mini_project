class Contact < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user

  validates :name, presence: true, length: { maximum: 40 }
  validates :user_id, presence: true
end
