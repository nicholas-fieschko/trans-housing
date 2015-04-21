Fabricator(:conversation) do

	# Get setup with some temporary users
	transient sender: 		Fabricate.build(:user)
	transient receiver:		Fabricate.build(:user)

	# Pass a block to insert their info into users array
	users									{ |attrs| [ attrs[:sender], attrs[:receiver] ] }

	# Make a message
	messages(count: 4)		{ |attrs, i|
														x = rand(2)
														(x == 1) ? (y = 0) : (y = 1)
														Fabricate(:message,
																			 sender:	 attrs[:users][x].id,
																			 receiver: attrs[:users][y].id)
																			 #sender: attrs[:sender].id,
																			 #receiver: attrs[:receiver].id)
												}

end
