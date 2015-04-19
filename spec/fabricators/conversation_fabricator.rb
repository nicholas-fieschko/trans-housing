require 'digest/sha1'

Fabricator(:conversation) do

	participants { 2.times.map { Fabricate(:user) } }

	messages { |attrs| Conversation.add_message(
			attrs[:participants][0], # Recipient
			attrs[:participants][1], # Sender
			Fabricate.build(:message)	 # Text
		) 
	}

	lookup_hash { Digest::SHA1.hexdigest 'foo' }
	#{ Conversation.get_lookup_hash(participants) }

end
