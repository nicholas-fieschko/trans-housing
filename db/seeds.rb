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







# Run the following two commands to seed the database:
# rake db:reset
# rake db:mongoid:create_indexes    # must do this or else will get Ajax error!

providers = Fabricate.times(50,:provider)
seekers = Fabricate.times(50,:seeker)

User.all.each do |u| 
  number_reviews = rand(5)
  sum_rating = 0
  for i in 1..number_reviews
    author = User.all.sample
    r = Fabricate(:review, authorID: author.id, author: author.name)
    r.update_attribute(:completed, 1)
      r.update_attribute(:expirable_created_at, nil)
    u.reviews.push(r)
    sum_rating += r.rating
  end
  u.update_attribute(:number_reviews, number_reviews)
  u.update_attribute(:sum_rating, sum_rating)
  u.update_attribute(:average_rating, (u.sum_rating / u.number_reviews).round(1))

end

