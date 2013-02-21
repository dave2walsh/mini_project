# == Schema Information
#
# Table name: contacts
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Contact < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user

  validates :name, presence: true, length: { maximum: 40 }
  validates :user_id, presence: true
end
