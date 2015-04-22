Fabricator(:review) do 


  authorID 					{ ObjectId() }
  author 					{ Faker::Name.first_name }
  text						{ Faker::Lorem.paragraph }
  rating					{ rand(1..5) }

  completed					true
  expirable_created_at		nil











end