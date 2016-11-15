# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@2359media.com', password: 'password', password_confirmation: 'password')
UserType.create!(name: 'Employee', discount: 50)
UserType.create!(name: 'Guest', discount: 0)
