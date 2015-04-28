Fabricator(:conversation) do

	# Generate a synergistic title for thread
	subject				{ Faker::Company.bs }

	# Get setup with some temporary users
	#transient sender: 	Fabricate.build(:user)
	#transient receiver:	Fabricate.build(:user)

	# OK, work on having multiple receivers AFTER getting views down...
	# pass a rand count to users and then set a sender in messages; the
	# receivers will just be everybody else
	users(count: 3)		{ Fabricate.build(:user) }
	#transient copy:		[1,2,3]

	# attrs can't get us into user_ids :(
	owners(count: 3)	{ Fabricate.build(:user).id }
	
	messages(rand: 4)	{ |attrs|
							x = rand( attrs[:users].length )
							Fabricate(
								:message, 
								sender: attrs[:users][x],
							)
						}

end
