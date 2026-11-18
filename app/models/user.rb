class User < ApplicationRecord
    has_secure_password 
    has_many :comments , dependent: :destroy
    has_many :project_users, dependent: :destroy
    has_many :projects , through: :project_users

    has_many :assigned_bugs , class_name: "Bug" , foreign_key: "assigned_to_id"
    has_many :reported_bugs , class_name: "Bug" , foreign_key: "reported_by_id"

    enum :role, {admin:0 , developer:1 , reporter:2} 
    validates :name , presence: true 
    normalizes :email, with: ->(email) { email.strip.downcase }
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { minimum: 8 }, allow_nil: true 

    
end
