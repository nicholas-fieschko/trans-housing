# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create!(name: 'richard', password: 'password', number_reviews: 0, contact: Contact.new(email: 'richang11@gmail.com'), location: Location.new(), gender: Gender.new())
User.create!(name: 'arnold', password: 'password', number_reviews: 0, contact: Contact.new(email: 'arnold.chang@gmail.com'), location: Location.new(), gender: Gender.new())
