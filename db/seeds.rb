# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#richard = User.create!(name: 'richard', password: 'password', contact: Contact.create!(email: "richard.chang@gmail.com", phone: 8888888), number_reviews: 0, location: Location.new(), gender: Gender.new(identity: "Male", trans: false))
#arnold = User.create!(name: 'arnold', password: 'password', contact: Contact.create!(email: "arnold.chang@gmail.com", phone: 8888888), number_reviews: 0, location: Location.new(), gender: Gender.new(identity: "Male", trans: false))
#david = User.create!(name: 'david', password: 'password', contact: Contact.create!(email: "david.chang@gmail.com", phone: 8888888), number_reviews: 0, location: Location.new(), gender: Gender.new(identity: "Male", trans: false))





Fabricate.times(10,:provider)
Fabricate.times(10,:seeker)




