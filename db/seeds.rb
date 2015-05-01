# Run the following two commands to seed the database:
# rake db:reset
# rake db:mongoid:create_indexes    # must do this or else will get Ajax error!

Fabricate.times(30,:provider)
Fabricate.times(30,:seeker)

User.all.each do |u| 
  number_exchanges = rand(5)
  for i in 1..number_exchanges
    provider = if u.provider? then u else User.providers.sample end
    seeker = if u.provider? then User.seekers.sample else u end

    provider_review_for_seeker = Fabricate(:review, reviewer_id: provider.id, recipient_id: seeker.id)
    seeker_review_for_provider = Fabricate(:review, reviewer_id: seeker.id, recipient_id: provider.id)
    provider_review_for_seeker.set_complete
    seeker_review_for_provider.set_complete
    seeker.reviews.push(provider_review_for_seeker)
    provider.reviews.push(seeker_review_for_provider)

    exchange = Fabricate(:exchange, provider_id: provider.id, seeker_id: seeker.id, 
                                    provider_review_for_seeker_id: provider_review_for_seeker.id, 
                                    seeker_review_for_provider_id: seeker_review_for_provider.id)
    exchange.set_complete
    seeker.exchanges.push(exchange)
    provider.exchanges.push(exchange)
  end
end

User.all.each do |u|
  u.update_attribute(:number_reviews, u.calculate_number_reviews)
  u.update_attribute(:sum_rating, u.calculate_sum_rating)
  u.update_attribute(:average_rating, u.calculate_average_rating)
end

