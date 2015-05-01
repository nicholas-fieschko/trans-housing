Fabricator(:review) do 


  recipient_id 				{ ObjectId() }
  reviewer_id				{ ObjectId() }
  text						{ Faker::Lorem.paragraph }
  rating					{ rand(1..5) }

  completed					true
  expirable_created_at		nil











end