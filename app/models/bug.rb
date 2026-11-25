class Bug < ApplicationRecord
  has_many_attached :images
  belongs_to :project
  belongs_to :developer , class_name: "User" , foreign_key: "assigned_to_id" , optional:true 
  belongs_to :reporter , class_name: "User" , foreign_key: "reported_by_id" 

  has_many :comments , dependent: :destroy
  has_one :email_log, dependent: :destroy

  enum :priority, { low: 0, medium: 1, high: 2 }, prefix: true, default: :low

  enum :status, { new_bug: 0, in_progress: 1, resolved: 2, closed: 3 }, prefix: true, default: :new

  scope :access_bugs, ->(user) {
    if user.admin? 
      all
    elsif user.reporter? 
      where(reported_by_id: user.id)
    elsif user.developer?
      where(assigned_to_id: user.id)
    end    
  }

  scope :search, ->(query){
    where("title ILIKE ?", "%#{query}%")
  }

  scope :dashboard_bugs, ->(user){
    user.admin? ? all : where(project_id: user.projects.select(:id))
  }

  validates :title , presence: true
  validate :acceptable_image

  private

  def acceptable_image
    allowed_types = %w[image/png image/jpeg image/webp]

      images.each do |image|
        unless allowed_types.include?(image.content_type)
          errors.add(:images, "must be PNG, JPG, or WEBP")
        end
      end
  end
end
