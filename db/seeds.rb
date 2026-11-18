# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


Comment.destroy_all
Bug.destroy_all
ProjectUser.destroy_all
Project.destroy_all
User.destroy_all

admin = User.create!(
  name: "Admin User",
  email: "admin@example.com",
  password: "password",
  role: :admin
)

reporter1 = User.create!(
  name: "Ali Reporter",
  email: "reporter1@example.com",
  password: "password",
  role: :reporter
)

reporter2 = User.create!(
  name: "Sara Reporter",
  email: "reporter2@example.com",
  password: "password",
  role: :reporter
)

developer1 = User.create!(
  name: "Ahmed Developer",
  email: "developer1@example.com",
  password: "password",
  role: :developer
)

developer2 = User.create!(
  name: "Hassan Developer",
  email: "developer2@example.com",
  password: "password",
  role: :developer
)

developer3 = User.create!(
  name: "Ayesha Developer",
  email: "developer3@example.com",
  password: "password",
  role: :developer
)

project1 = Project.create!(
  name: "E-Commerce Website",
  description: "Online shopping platform"
)

project2 = Project.create!(
  name: "Hospital Management",
  description: "Hospital management system"
)

project3 = Project.create!(
  name: "Learning Management System",
  description: "Online learning platform"
)

project1.users << [reporter1, developer1, developer2]
project2.users << [reporter1, reporter2, developer2, developer3]
project3.users << [reporter2, developer1, developer3]


Bug.create!(
  title: "Login button not working",
  description: "Users cannot log in after entering valid credentials.",
  priority: :high,
  status: :new_bug,
  project: project1,
  reporter: reporter1,
  developer: developer1
)

Bug.create!(
  title: "Product image not loading",
  description: "Product images are missing on the product details page.",
  priority: :medium,
  status: :in_progress,
  project: project1,
  reporter: reporter1,
  developer: developer2
)

Bug.create!(
  title: "Cart total calculation incorrect",
  description: "The cart displays an incorrect total after applying a discount.",
  priority: :high,
  status: :resolved,
  project: project1,
  reporter: reporter1,
  developer: developer1
)

Bug.create!(
  title: "Patient record not saving",
  description: "New patient records are not saved in the database.",
  priority: :high,
  status: :new_bug,
  project: project2,
  reporter: reporter2,
  developer: developer3
)

Bug.create!(
  title: "Appointment date showing incorrectly",
  description: "The appointment date is displayed one day earlier.",
  priority: :low,
  status: :closed,
  project: project2,
  reporter: reporter1,
  developer: developer2
)

Bug.create!(
  title: "Course video not playing",
  description: "Students cannot play uploaded course videos.",
  priority: :medium,
  status: :in_progress,
  project: project3,
  reporter: reporter2,
  developer: developer1
)

puts "Seed data created successfully!"
