Fabricator(:exchange) do 


  provider_id 						{ ObjectId() }
  seeker_id							{ ObjectId() }
  provider_review_for_seeker_id		{ ObjectId() }
  seeker_review_for_provider_id		{ ObjectId() }

  completed							true
  expirable_created_at				nil











end