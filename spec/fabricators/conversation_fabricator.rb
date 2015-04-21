Fabricator(:conversation) do

	transient sender: 		Fabricate.build(:user)
	transient receiver:		Fabricate.build(:user)

	users									{ |attrs| [ attrs[:sender], attrs[:receiver] ] }

	messages							{ |attrs| [
																		Fabricate(:message,
																						 	sender: attrs[:sender].id,
																							receiver: attrs[:receiver].id)
																	] 
												}
end
