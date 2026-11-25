class Project < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users

  has_many :bugs, dependent: :destroy

  validates :name , presence: true

  scope :access_project, ->(user) {
    user.admin? ? all : user.projects
  }
end