require 'digest/sha1'

Fabricator(:conversation) do

	lookup_hash { Digest::SHA1.hexdigest 'foo' }

	participants { 2.times.map { Fabricate.build(:user) } }

	messages { |attrs| Conversation.add_message(
			attrs[:participants][0], # Recipient
			attrs[:participants][1], # Sender
			Fabricate.build(:message)	 # Text
		).messages 
	}

	#lookup_hash { |attrs| attrs[:messages].lookup_hash }

	#{ Conversation.get_lookup_hash(participants) }

end
