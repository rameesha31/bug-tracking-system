class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :developer , class_name: "User" , foreign_key: "assigned_to_id" , optional:true 
  belongs_to :reporter , class_name: "User" , foreign_key: "reported_by_id" 

  has_many :comments , dependent: :destroy

  enum :priority, { low: 0, medium: 1, high: 2 }, prefix: true, default: :low

  enum :status, { new_bug: 0, in_progress: 1, resolved: 2, closed: 3 }, prefix: true, default: :new

  validates :title , presence: true
end
